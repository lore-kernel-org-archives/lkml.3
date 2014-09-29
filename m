Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaI2Xwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:52:44 -0400
Received: from 60.Red-83-46-69.dynamicIP.rima-tde.net ([83.46.69.60]:42780
	"EHLO xiscosoft.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaI2Xwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:52:43 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Sep 2014 19:52:42 EDT
Message-ID: <5429EE7B.1070404@xiscosoft.sinip.es>
Date: Tue, 30 Sep 2014 01:42:51 +0200
From: klondike <klondike@xiscosoft.sinip.es>
Reply-To: klondike@xiscosoft.sinip.es
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: P J P <ppandit@redhat.com>
CC: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] initramfs: allow again choice of the embedded compression
 algorithm
References: <54239E69.4050803@klondike.es> <alpine.LFD.2.10.1409291328290.15448@wniryva.cad.erqung.pbz>
In-Reply-To: <alpine.LFD.2.10.1409291328290.15448@wniryva.cad.erqung.pbz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 29/09/14 10:08, P J P escribió:
>    Hello Klondike,
Hi!
> +-- On Thu, 25 Sep 2014, klondike wrote --+
> | Despite embedding an uncompressed initramfs, a user may want to allow for a
> | compressed extra initramfs to be passed using the rd system, for example to
> | boot a recovery system. Commit 9ba4bcb645898d562498ea66a0df958ef0e7a68c
> | ("initramfs: read CONFIG_RD_ variables for initramfs compression") broke
> | that behavior by making the choice based on CONFIG_RD_* instead of adding
> | CONFIG_INITRAMFS_COMPRESSION_LZ4. Saddly, CONFIG_RD_* is also used to
> | choose the supported RD compression algorithms by the kernel and a user may
> | want to suppport more than one.
>
>   Ie. on embedded systems they use CONFIG_INITRAMFS_COMPRESSION_* options to 
> compress ram disk and on other platforms they use CONFIG_RD_* options?
No, instead CONFIG_RD_* defines the compression formats supported by the
kernel when parsing an initramfs (either embedded into the kernel or
passed by the bootloader) whilst one of CONFIG_INITRAMFS_COMPRESSION_*
is used to choose the one that will be used on the initramfs embedded
into the kernel.

Just to make sure we are using the same terms, a system using a kernel
with an embedded intramfs isn't necessarily an embedded system, for
example I use such on my Gentoo systems which involve both servers and
Desktops.
> | As a result the following options are added or readed affecting the embedded
> | initramfs compression:
> | INITRAMFS_COMPRESSION_NONE Do no compression
> | INITRAMFS_COMPRESSION_GZIP Compress using gzip
> | INITRAMFS_COMPRESSION_BZIP2 Compress using bzip2
> | INITRAMFS_COMPRESSION_LZMA Compress using lzma
> | INITRAMFS_COMPRESSION_XZ Compress using xz
> | INITRAMFS_COMPRESSION_LZO Compress using lzo
> | INITRAMFS_COMPRESSION_LZ4 Compress using lz4
>
>   I haven't tested the patch yet, but does it preserve the CONFIG_RD_* 
> options' functionality?
Yes, except choosing the compression algorithm for the embedded
initramfs (which will default to gzip). For older kernels this means the
user will now experience the intended behaviour, for newer ones it means
that users using expert settings and an embedded initramfs will be asked
for the compression algorithm to be used (with the list of those
available depending on the CONFIG_RD_* options choosen), whilst normal
users will default to gzip compression.
> Would unifying the two options into one be a good idea?
I'm not a Kconfig wizard (more like a wizzard) so I'm not sure if such a
thing is possible. Basically we need a way to choose compression methods
supported (more to enforce the appropriate dependencies according to my
understanding of the code) and a way to choose the particular one used
for the embedded initramfs, as basing this choice in the selected method
may not always be a good idea (in my setups using a non compressed
embedded initramfs works best but external initramfs used for example to
do recovery may be compressed using xz). Of course on an embedded system
with serious memory constrains it may make more sense for example to
compress the embedded initramfs to reduce memory usage during boot. So
if you have suggestions on how to do this with a single option please
share them :)

klondike
