Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaBZQqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:46:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbaBZQqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:46:00 -0500
Message-ID: <530E1A35.40506@zytor.com>
Date: Wed, 26 Feb 2014 08:45:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Chris Bainbridge <chris.bainbridge@gmail.com>
CC: davej@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
References: <20140225060146.GA4339@debian.local> <530C7465.2080600@zytor.com> <20140225162611.GA31902@redhat.com> <530CCFD2.3050007@zytor.com> <20140226121256.GA8494@debian.local> <20140226164433.GA19341@srcf.ucam.org>
In-Reply-To: <20140226164433.GA19341@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 08:44 AM, Matthew Garrett wrote:
> On Wed, Feb 26, 2014 at 07:12:59PM +0700, Chris Bainbridge wrote:
> 
>> The basic findings of the bug discussion is that people are successfully
>> running PAE kernels on Pentium M (for some unknown reason Grub skips the
>> validate_cpu code in the kernel, so existing PAE kernels will run
>> unmodified, although they do fail when booted with syslinux), and people
>> are using a user-space hack to add "pae" to /proc/cpuinfo.
> 
> grub is jumping to the 32-bit entry point and skipping the entire real 
> mode setup code. Bad grub.
> 

Yes.  Grub can be made to behave sanely by using "linux16" and
"initrd16", but of course none of the distros do it that way.

There are much worse problems with that.

	-hpa

