Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaBZWrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:47:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaBZWrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:47:37 -0500
Message-ID: <530E6EEA.3080003@zytor.com>
Date: Wed, 26 Feb 2014 14:47:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 12/12] Add option to automatically set trusted_kernel
 when in Secure Boot mode
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>	<1393445473-15068-13-git-send-email-matthew.garrett@nebula.com> <20140226224141.1741a746@alan.etchedpixels.co.uk>
In-Reply-To: <20140226224141.1741a746@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 02:41 PM, One Thousand Gnomes wrote:
> On Wed, 26 Feb 2014 15:11:13 -0500
> Matthew Garrett <matthew.garrett@nebula.com> wrote:
> 
>> UEFI Secure Boot provides a mechanism for ensuring that the firmware will
>> only load signed bootloaders and kernels. Certain use cases may also
>> require that the kernel prevent userspace from inserting untrusted kernel
>> code at runtime. Add a configuration option that enforces this automatically
>> when enabled.
> 
> I think you have a load more cases to attempt to paper over before you
> even pretend to achieve that goal. Firewire for example. Also it only
> remotely begins to work if you also force CAP_SYS_RAWIO off globally as
> you need to force off things like raw command issuing to various
> controllers (especially as some of that code is written on the basis that
> 'its RAWIO, screw making it secure and doing all the checks we could
> bother with'.
> 
> RAWIO also disables things like CPU msr access - which is also quite
> adequate for subverting a kernel.
> 
> Another issue that needs addressing is firmware. Quite a few of our
> request_firmware cases load device firmware which is not signed into DMA
> capable hardware. Probably also worth checking what the
> architectural guarantees on bogus microcode updates is. Maybe we need
> firmware signing for such cases to match the mod signing ?
> 
> I'm trying to think what else. Possibly disabling it on Pentium-M with
> the rep movs erratum (Y19) as it's quite possible to set up suitable
> adjacent page sets in user space via the graphics.
> 

I have been arguing for a long time that this should disable RAWIO.  The
argument was that apparently some SCSI controllers started requiring
RAWIO to do things like update firmware... which is arguably equally
problematic, but either way is (a) clearly wrong and (b) started a long,
never-ending discussion...

	-hpa


