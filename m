Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbaHVOYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:24:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329AbaHVOYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:24:41 -0400
Message-ID: <53F752A2.7080604@redhat.com>
Date: Fri, 22 Aug 2014 16:24:34 +0200
From: Harald Hoyer <harald@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
CC: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
References: <53E62EEF.9040801@gmail.com>
In-Reply-To: <53E62EEF.9040801@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.08.2014 16:23, Mantas Mikulėnas wrote:
> As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"),
> the kernel freezes at the earliest possible moment when trying to boot
> via UEFI on my Asus laptop. (It still boots via BIOS.)
> 
> If I revert that commit on current master (c309bfa9b481), it boots
> correctly again [although I see "setup_efi_pci() failed" being printed].
> 
> (Seems like it freezes when handle_cmdline_files() attempts to read
> the last chunk of the initramfs -- the last call to efi_file_read()
> never returns. Figuring out why that happens is beyond me, though.)
> 

I fixed my issue with: https://lkml.org/lkml/2014/8/22/232

Care to test?
