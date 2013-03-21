Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab3CUOSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:18:40 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48281 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3CUOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJtyJaVnUZXkWdma8YydpU6tEF2KEhrWz+uq6D142gDwX3fATg@mail.gmail.com>
References: <CAJsYZ5ksvPCR2O39=sj9zeptfppP1w6FM08rw8Aw+L+2dEPCnQ@mail.gmail.com>
	<20130320165339.GA28307@kroah.com>
	<CAJsYZ5n40mBCd6x7baQ6MLw1HBAa3cfebm+Aa533uxYVP86o9Q@mail.gmail.com>
	<CAJtyJaVnUZXkWdma8YydpU6tEF2KEhrWz+uq6D142gDwX3fATg@mail.gmail.com>
Date: Thu, 21 Mar 2013 10:18:38 -0400
Message-ID: <CAG6tG3xyZYWgB2nUwwu8mmkSJza-cXym6iHivOUSJuYf3pV5_w@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_mmap and ashmem_read
From: Robert Love <rlove@google.com>
To: Bjorn Bringert <bringert@google.com>
Cc: Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:06 AM, Bjorn Bringert <bringert@google.com> wrote:
> I did implement ashmem_read, but I had no idea what I was doing. Calling the
> VFS read function seemed like an obvious way to do it, but it might be
> wrong. If that needs fixing, then the similar VFS call in ashmem_llseek
> probably needs fixing too.

You don't want to hold ashmem_mutex across the VFS calls. It is only
needed to protect the ashmem-internal structures.

FWIW is Android now using ashmem_read()? I left it out of the original
ashmem implementation on purpose.

        Robert
