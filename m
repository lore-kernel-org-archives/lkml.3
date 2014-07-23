Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614AbaGWVGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:06:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbaGWVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:06:07 -0400
Message-ID: <1406149558.3612.37.camel@fourier>
Subject: Re: [PATCH 3.8 076/116] xfs: ioctl check for capabilities in the
 current user namespace
From: Kamal Mostafa <kamal@canonical.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Dwight Engen <dwight.engen@oracle.com>,
        Ben Myers <bpm@sgi.com>
Date: Wed, 23 Jul 2014 14:05:58 -0700
In-Reply-To: <20140722231257.GT4453@dastard>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
	 <1406067727-19683-77-git-send-email-kamal@canonical.com>
	 <20140722231257.GT4453@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 09:12 +1000, Dave Chinner wrote:
> On Tue, Jul 22, 2014 at 03:21:27PM -0700, Kamal Mostafa wrote:
> > 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dwight Engen <dwight.engen@oracle.com>
> > 
> > commit fd5e2aa8653665ae1cc60f7aca1069abdbcad3f6 upstream.
> > 
> > Use inode_capable() to check if SUID|SGID bits should be cleared to match
> > [...]
> 
> Why are you backporting this to 3.8? namespace support didn't come
> along until much later, so grabbing one patch out of themiddle of a
> patch series to allow userns support in XFS is likely to cause
> problems because there's no supporting code in XFS it.
> 
> Please don't randomly cherry pick userns support patches that change
> permission checks back into kernels that don't have userns support.

Yup, that's why we ask for reviews all right!  I've dropped these from
the 3.8-stable queue:

    fs,userns: Change inode_capable to capable_wrt_inode_uidgid
    xfs: ioctl check for capabilities in the current user namespace

Thanks Dave,

 -Kamal


