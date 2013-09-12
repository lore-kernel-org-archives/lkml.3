Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3ILSCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:02:54 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:43863 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab3ILSCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:02:52 -0400
Message-ID: <5232018F.3000009@iki.fi>
Date: Thu, 12 Sep 2013 21:01:51 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH -next] staging/media: fix msi3101 build errors
References: <20130912143402.73f77e0cef1e19576b77a6b5@canb.auug.org.au> <5231FCFC.40505@infradead.org>
In-Reply-To: <5231FCFC.40505@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.186.45
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,
It is already fixed, waiting for Mauro's processing.
https://patchwork.kernel.org/patch/2856771/

regards
Antti

On 09/12/2013 08:42 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix build error when VIDEOBUF2_CORE=m and USB_MSI3101=y.
>
> drivers/built-in.o: In function `msi3101_buf_queue':
> sdr-msi3101.c:(.text+0x1298d6): undefined reference to `vb2_buffer_done'
> drivers/built-in.o: In function `msi3101_cleanup_queued_bufs':
> sdr-msi3101.c:(.text+0x1299c7): undefined reference to `vb2_buffer_done'
> drivers/built-in.o: In function `msi3101_isoc_handler':
> sdr-msi3101.c:(.text+0x12a08d): undefined reference to `vb2_plane_vaddr'
> sdr-msi3101.c:(.text+0x12a0b9): undefined reference to `vb2_buffer_done'
> drivers/built-in.o: In function `msi3101_probe':
> sdr-msi3101.c:(.text+0x12a1c5): undefined reference to `vb2_vmalloc_memops'
> sdr-msi3101.c:(.text+0x12a1d7): undefined reference to `vb2_queue_init'
> drivers/built-in.o:(.rodata+0x34cf0): undefined reference to `vb2_ioctl_reqbufs'
> drivers/built-in.o:(.rodata+0x34cf4): undefined reference to `vb2_ioctl_querybuf'
> drivers/built-in.o:(.rodata+0x34cf8): undefined reference to `vb2_ioctl_qbuf'
> drivers/built-in.o:(.rodata+0x34d00): undefined reference to `vb2_ioctl_dqbuf'
> drivers/built-in.o:(.rodata+0x34d04): undefined reference to `vb2_ioctl_create_bufs'
> drivers/built-in.o:(.rodata+0x34d08): undefined reference to `vb2_ioctl_prepare_buf'
> drivers/built-in.o:(.rodata+0x34d18): undefined reference to `vb2_ioctl_streamon'
> drivers/built-in.o:(.rodata+0x34d1c): undefined reference to `vb2_ioctl_streamoff'
> drivers/built-in.o:(.rodata+0x35580): undefined reference to `vb2_fop_read'
> drivers/built-in.o:(.rodata+0x35588): undefined reference to `vb2_fop_poll'
> drivers/built-in.o:(.rodata+0x35598): undefined reference to `vb2_fop_mmap'
> drivers/built-in.o:(.rodata+0x355a0): undefined reference to `vb2_fop_release'
> drivers/built-in.o:(.data+0x23b40): undefined reference to `vb2_ops_wait_prepare'
> drivers/built-in.o:(.data+0x23b44): undefined reference to `vb2_ops_wait_finish'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Antti Palosaari <crope@iki.fi>
> ---
>   drivers/staging/media/msi3101/Kconfig |    2 ++
>   1 file changed, 2 insertions(+)
>
> --- linux-next-20130912.orig/drivers/staging/media/msi3101/Kconfig
> +++ linux-next-20130912/drivers/staging/media/msi3101/Kconfig
> @@ -1,3 +1,5 @@
>   config USB_MSI3101
>   	tristate "Mirics MSi3101 SDR Dongle"
>   	depends on USB && VIDEO_DEV && VIDEO_V4L2
> +	select VIDEOBUF2_CORE
> +	select VIDEOBUF2_VMALLOC
>


-- 
http://palosaari.fi/
