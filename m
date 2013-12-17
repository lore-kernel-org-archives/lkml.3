Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3LQSCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:02:40 -0500
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:59531 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3LQSCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:02:39 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH] scsi: int overflow in st_ioctl()
From: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= 
	<kai.makisara@kolumbus.fi>
In-Reply-To: <1387291383-25126-1-git-send-email-xuyongjiande@gmail.com>
Date: Tue, 17 Dec 2013 19:53:52 +0200
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F1B567DD-C322-4BA7-BFEA-E7C4B1F82697@kolumbus.fi>
References: <1387291383-25126-1-git-send-email-xuyongjiande@gmail.com>
To: xuyongjiande@gmail.com
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.12.2013, at 16.43, Yongjian Xu xuyongjiande@gmail.com wrote:

> From: Yongjian Xu <xuyongjiande@gmail.com>
> 
> mtc.mt_count comes from user-space.
> int overflow may occur:
> mtc.mt_count++;
> mtc.mt_count—;

I agree that this is a problem. However, it seems that there is also another problem: the SPACE command uses a 24-bit count field and this overflows far below INT_MAX. Should the count in MTFSF etc. be limited to (2<<24-2)? This would make the checks you suggest unnecessary. (-2 so that the behavior does not depend on whether we are at file mark or not.)

I am a bit hesitant with this suggestion because someone may use count INT_MAX to space to the end of the tape. This probably succeeds now but after the fix it would return an error.

Thanks,
Kai

