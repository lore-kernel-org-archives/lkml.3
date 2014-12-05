Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaLETyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:54:24 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46917 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaLETyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:54:02 -0500
MIME-Version: 1.0
In-Reply-To: <m3iohq7yem.fsf@adixit-yct.ra.intel.com>
References: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
 <CALZtONBUDyN7OOMV9ziDXMhFN9+bOcsYvJ0an_7T0VV0Hz+8WQ@mail.gmail.com> <m3iohq7yem.fsf@adixit-yct.ra.intel.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Fri, 5 Dec 2014 14:53:40 -0500
X-Google-Sender-Auth: B7JkX0MI1nAco_XZP-yYCBQDlhw
Message-ID: <CALZtONA2uk7ZN=f5S-DnmcOwhqtzLXmppk48YqfgjwA+vQuhtw@mail.gmail.com>
Subject: Re: [PATCH linux-next] Documentation: Build mic/mpssd only for x86_64
To: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Jiri Kosina <jkosina@suse.cz>,
        Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jennings <sjennings@variantweb.net>,
        "Yokoyama, Caz" <caz.yokoyama@intel.com>,
        "Dutt, Sudeep" <sudeep.dutt@intel.com>,
        "Chandramouli, Dasaratharaman" 
	<dasaratharaman.chandramouli@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 1:18 PM, Ashutosh Dixit <ashutosh.dixit@intel.com> wrote:
> On Thu, Dec 04 2014 at 07:27:06 PM, Dan Streetman <ddstreet@ieee.org> wrote:
>> On Thu, Dec 4, 2014 at 4:27 PM, Ashutosh Dixit <ashutosh.dixit@intel.com> wrote:
>>> mic/mpssd along with MIC drivers are currently only usable on
>>> x86_64. So build mic/mpssd only for x86_64 to avoid build breaks on
>>> big-endian systems.
>>
>> Only building for x86_64 is fine, but in that case what's the point of
>> leaving the htole16() et. al. functions in mpssd.c?  Shouldn't they be
>> removed?
>
> I am hoping that once glibc is fixed we can remove this limitation on
> building only for x86_64, so I'd rather htole16() et. al. stayed.

FYI, the bug I opened with glibc:
https://sourceware.org/bugzilla/show_bug.cgi?id=17679

was rejected because Andreas states "C does not allow function calls
in file scope."  The suggestion was made to try to fix gcc, but
honestly I don't have the time (or energy) to push for a gcc change
just for this. :-)

I do think it's too bad that glibc hto* functions don't work in file
scope (i.e. with static/global var initialization) for constant values
(using them with variables is different, which is why
__bswap_constant_* works in file scope but __bswap_* doesn't), since
it's simply a 2-step process that's entirely doable by the
preprocessor and/or compiler; just check if target endianness matches
desired endianness, and if not the compiler does a simple byte swap of
the constant value.

Anyway, I doubt glibc and/or gcc will be updated anytime soon to allow this.

>  As I
> said earlier, I'm fine with your patch too, but restricting the build
> for x86_64 seems to be the smallest patch which provides an acceptable
> solution.

Fine with me too.  It'll get big-endian building again.
