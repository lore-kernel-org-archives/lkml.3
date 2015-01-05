Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbbAERqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:46:44 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47955 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbbAERqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:46:42 -0500
Message-ID: <54AACE00.8060407@lwfinger.net>
Date: Mon, 05 Jan 2015 11:46:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, Kalle Valo <kvalo@codeaurora.org>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, stefano.brivio@polimi.it,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:net:wireless: Add proper locking for the function,
 b43_op_beacon_set_tim in main.c
References: <1420184041-6788-1-git-send-email-xerofoify@gmail.com> <87tx05378x.fsf@kamboji.qca.qualcomm.com> <54AAC6EE.2000603@gmail.com>
In-Reply-To: <54AAC6EE.2000603@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 11:16 AM, nick wrote:
> Kalle,
> That's fine. On the other hand I am interested in the
> reasons why this patch was dropped so I can send in a
> version 2 of this patch.
> Regards Nick

Apparently you missed Michael Büsch's comment:

"Thanks for the patch.

However, this does not work. We are in atomic context here.
Please see the b43-dev mailing list archives for a recent thread about that.
I'm also pretty sure that this is safe without lock, due to the higher level 
locks in mac80211."

Did you actually test the patch? If Michael is right, and I trust him on this 
matter, your patch should lock the system.

Larry

