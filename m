Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3F0Jmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:42:36 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34503 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3F0Jme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:42:34 -0400
Message-ID: <51CC08FC.6000301@linux.vnet.ibm.com>
Date: Thu, 27 Jun 2013 15:12:20 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Kees Cook <keescook@chromium.org>,
        "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        Colin Cross <ccross@android.com>, LKML <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] powerpc/pseries: Support compression of oops text
 via pstore
References: <20130624061936.12963.72529.stgit@aruna-ThinkPad-T420> <20130624062316.12963.87911.stgit@aruna-ThinkPad-T420> <CAGXu5jJezRynWEBmmH8wp=pt1yEjukhe6Pg_aRcZP7E6t-1R=g@mail.gmail.com> <51C94101.3030702@linux.vnet.ibm.com> <3908561D78D1C84285E8C5FCA982C28F31C5376F@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C5376F@ORSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062709-7014-0000-0000-0000033CEE72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tuesday 25 June 2013 09:32 PM, Luck, Tony wrote:
>> Introducing headersize in pstore_write() API would need changes at
>> multiple places whereits being called. The idea is to move the
>> compression support to pstore infrastructure so that other platforms
>> could also make use of it.
> Any thoughts on the back/forward compatibility as we switch to compressed
> pstore data?   E.g. imagine I have a system installed with some Linux distribution
> with a kernel too old to know about compressed pstore. I use that machine to
> run the latest kernels that do compression ... and one fine day one of them crashes
> hard - logging in compressed form to pstore. Now I boot my distro kernel to pick
> up the pieces ... what do I see in /sys/fs/pstore/*? Some compressed files? Can I
> read them with some tool?
>
> This somewhat of a corner case - but not completely unrealistic ... I'd at least
> like to be reassured that the old kernel won't choke when it sees the compressed
> blobs.

openssl command line tool can be used to decompress the compressed data of
the pstore file in the above scenario.

Usage:

cat <file> | openssl zlib -d

> -Tony
>

