Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaGOPeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:34:50 -0400
Received: from duck.fensystems.co.uk ([212.13.204.60]:43952 "EHLO
	duck.fensystems.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaGOPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:34:48 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 11:34:48 EDT
Message-ID: <53C547A5.3030500@fensystems.co.uk>
Date: Tue, 15 Jul 2014 16:24:21 +0100
From: Michael Brown <mbrown@fensystems.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Yinghai Lu <yinghai@kernel.org>
CC: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org> <20140618142819.GN24049@console-pimps.org> <20140709182651.GB15932@console-pimps.org> <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com> <20140711074029.GD5952@console-pimps.org> <20140715151025.GB32039@console-pimps.org>
In-Reply-To: <20140715151025.GB32039@console-pimps.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 16:10, Matt Fleming wrote:
> Going forward, I suspect any attempts to use the EFI File Protocol are
> going to result in this kind of breakage, and that the only thing that
> can be relied upon is the Disk I/O Protocol.
>
> But doing Disk I/O would necessitate adding the in-kernel FAT driver to
> the EFI boot stub, which is a scary idea (though not without merit).

Booting via iPXE will give you an EFI_SIMPLE_FILE_SYSTEM_PROTOCOL 
(providing access to the initrd previously downloaded by iPXE).  It will 
also give you a dummy disk I/O protocol which always return EFI_NO_MEDIA.

In those circumstances, only the EFI_SIMPLE_FILE_SYSTEM_PROTOCOL will work.

Michael
