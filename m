Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbbAYIOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 03:14:24 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:38649 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbAYIOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 03:14:22 -0500
MIME-Version: 1.0
In-Reply-To: <1422169574-8451-1-git-send-email-xerofoify@gmail.com>
References: <1422169574-8451-1-git-send-email-xerofoify@gmail.com>
Date: Sun, 25 Jan 2015 09:14:20 +0100
Message-ID: <CACna6rzO=7FW3YxWZEDejT++EB2ZfWTSA7Dg-0RcHwKEqn6Z=g@mail.gmail.com>
Subject: Re: [PATCH] net:wireless:Add proper locking for the function,
 b43_op_beacon_set_tim in main.c
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 January 2015 at 08:06, Nicholas Krause <xerofoify@gmail.com> wrote:
> Adds proper locking for the function, b43_op_beacon_set_tim in main.c that internally calls b43_update_templates.
> Due to the function that is being called internally,b43_update_templates needing the mutex lock of the structure
> pointer wl passed  it to run successfully and without issues we add the calls to mutex_lock before and mutex_unlock
> after it's call internally in b43_op_beacon_set_tim in order to allow the function,,b43_update_templates to run
> successfully and without issues related to concurrent access.

Nack
