Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216Ab3JQDYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:24:00 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49107 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432Ab3JQDX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:23:58 -0400
Message-ID: <525F584C.5010106@lwfinger.net>
Date: Wed, 16 Oct 2013 22:23:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Christopher Li" <sparse@chrisli.org>
CC: Linux-Sparse <linux-sparse@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: sparse: possible false report of context imbalance
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sparse reports the following:

   CHECK   drivers/staging/rtl8188eu/core/rtw_mlme.c
drivers/staging/rtl8188eu/core/rtw_mlme.c:1003:9: warning: context imbalance in 
'rtw_free_assoc_resources' - different lock contexts for basic block

The code in question is as follows:

         if (lock_scanned_queue)
                 spin_lock_bh(&(pmlmepriv->scanned_queue.lock));

         pwlan = rtw_find_network(&pmlmepriv->scanned_queue, 
tgt_network->network.MacAddress);

         if (lock_scanned_queue)
                 spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));

As this fragment uses the identical test to unlock that is used to lock, and the 
test variable is not touched, I think this is a false indication. I am using 
version 0.4.4 of sparse.

Thanks,

Larry
