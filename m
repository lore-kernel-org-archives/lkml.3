Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaESP6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:58:15 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:42154 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaESP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140519092119.GT15585@mwanda>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
 <1400385604-21086-3-git-send-email-matlackdavid@gmail.com> <20140519092119.GT15585@mwanda>
From: David Matlack <matlackdavid@gmail.com>
Date: Mon, 19 May 2014 08:57:49 -0700
Message-ID: <CANoiuGLjBwitL_==2xVQ_021p=3uOCf2qwqWYdrmiRE7rQM0FQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: slicoss: remove slic_reg_params struct
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        charrer@alacritech.com, linux-kernel@vger.kernel.org,
        Lior Dotan <liodot@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 2:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Looking at the patch, this looks like a bugfix but the changelog doesn't
> give any clues.

Yeah this isn't a bug fix.

The only member of struct slic_reg_params that was in use was fail_on_bad_eeprom
(implicitly set to zero by alloc_etherdev -> kzalloc). Since the previous patch
in this series fixes the eeprom checksum, we can remove this struct entirely.

If we do want the feature of ignoring a corrupt/bad eeprom, a module param
would work better anyway.
