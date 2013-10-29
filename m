Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3J2WPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:15:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3J2WPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:15:09 -0400
Date: Tue, 29 Oct 2013 15:15:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Read CONFIG_RD_ variables for initramfs compression
Message-Id: <20131029151507.8f63dad8e7525e33431d9596@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.03.1310152002200.7552@erqung.pbz>
References: <alpine.LFD.2.03.1310152002200.7552@erqung.pbz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 20:25:57 +0530 (IST) P J P <ppandit@redhat.com> wrote:

> When expert configuration option(CONFIG_EXPERT) is enabled,
> menuconfig offers a choice of compression algorithm to compress
> initial ramfs image; This choice is stored into CONFIG_RD_*
> variables. But usr/Makefile uses earlier INITRAMFS_COMPRESSION_*
> macros to build initial ramfs file. Since none of them is defined,
> resulting 'initramfs_data.cpio' file remains un-compressed.
> 
> This patch updates the Makefile to use CONFIG_RD_* variables and
> adds support for LZ4 compression algorithm.

This patch breaks my x86_64 allmodconfig build, because I don't have
the lz4 executable installed:

/usr/src/25/scripts/gen_initramfs_list.sh: line 307: lz4: command not found
make[1]: *** [usr/initramfs_data.cpio.lz4] Error 1

This obviously isn't acceptable!
