Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163273Ab3DFJrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 05:47:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:57600 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163260Ab3DFJry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 05:47:54 -0400
X-Spam-Score: -100.8
Message-ID: <515FEF2C.4080705@asianux.com>
Date: Sat, 06 Apr 2013 17:47:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Mirsal Ennaime <mirsal@mirsal.fr>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: Android: looping issue, need break when get
 value firstly.
References: <515E85C5.7010706@asianux.com> <20130405220156.GC31680@kroah.com> <CAMP5Xgd=wVrDVCc84L2kMk9ADy7avokB6D=4+kdAm8jF+NLVyg@mail.gmail.com>
In-Reply-To: <CAMP5Xgd=wVrDVCc84L2kMk9ADy7avokB6D=4+kdAm8jF+NLVyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月06日 07:48, � wrote:
> Theoretically this should not change the behavior. The purpose of this
> code it to make sure only thread per process is part of a transaction
> stack, so if it finds more than one transaction with a matching
> process, they should all point to the same thread object. I think a
> better change description is needed though.

  after reading code again, I think:
    in our condition, one proc can be related with multiple threads.

  can you provide more information for:
    why can we be sure "they should all point to the same thread object" ?

  result:
    if it is an issue (can not be sure all point to the same thread object)
      it seems need additional considerations for it.
      what my fix seems incorrect, either.
        (for its transaction processing, it seems not should obey stack rules).

    else (can be sure)
      my patch seems minor (only can increasing a little performance).
      it is not quite suitable to spend much time to test a minor patch !!

    so whether what will happen, my patch seems obsoleted !!

  :-(


-- 
Chen Gang

Asianux Corporation
