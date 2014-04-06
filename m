Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaDFSlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 14:41:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45901 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbaDFSk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 14:40:59 -0400
Message-ID: <53419F84.2090204@zytor.com>
Date: Sun, 06 Apr 2014 11:40:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
References: <20140404064120.GB11877@gmail.com>	<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>	<20140404080006.GB6944@gmail.com>	<533EB5F1.8060002@linux.intel.com>	<20140404151359.GB12370@srcf.ucam.org> <20140406184023.1e31412d@alan.etchedpixels.co.uk>
In-Reply-To: <20140406184023.1e31412d@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2014 10:40 AM, One Thousand Gnomes wrote:
> On Fri, 4 Apr 2014 16:13:59 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
>> On Fri, Apr 04, 2014 at 09:38:57PM +0800, Li, Aubrey wrote:
>>
>>> I don't think there is enough justification to revert the patch. We
>>> introduce EFI into the default list, we didn't see any reason to remove
>>> it out so far.
>>
>> We should be using the EFI method, yes. But it seems that CF9 isn't 
>> safe, so we should drop that.
>>
> 
> Windows does not use CF9 and there are known, documented cases where CF9
> will not work reliably. That includes reliable reboot on some Baytrail
> systems. (Erratum VLT60 and VLT62).
> 
> So we really shouldn't be doing 0xCF9 except as a last resort if we are
> still alive and have been through the official reboot methods.
> 

No question. The question at hand is if we should do it after all other
non-terminal (BIOS, triple) methods have been tried.

	-hpa


