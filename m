Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbaIWWtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:49:33 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:50887 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbaIWWtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:49:31 -0400
Date: Tue, 23 Sep 2014 18:49:26 -0400
From: Jeff Layton <jlayton@samba.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression]  cifs: sanity check length of data to send before
 sending
Message-ID: <20140923184926.2fdbb6c6@tlielax.poochiereds.net>
In-Reply-To: <5421C563.8070304@canonical.com>
References: <5421C563.8070304@canonical.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 15:09:23 -0400
Joseph Salisbury <joseph.salisbury@canonical.com> wrote:

> Hi Jeff,
> 
> A kernel bug report was opened against Ubuntu [0].  It was found that
> reverting the following commit resolved this bug:
> 
> 
> commit a26054d184763969a411e3939fe243516715ff59
> Author: Jeff Layton <jlayton@redhat.com>
> Date:   Fri Feb 14 07:21:00 2014 -0500
> 
>     cifs: sanity check length of data to send before sending
> 
>       
> The regression was introduced as of v3.14-rc7.
> 
> It appears the patch may be doing what it is supposed to, since the
> send_length != smb_buf_length:
> send_length=72
> and
> smb_buf_length=2164260932
> 
> However, without this check and WARN/return of -EIO the samba
> connections still work correctly.
> 
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?
>     
> Thanks,
>     
> Joe
> 
> [0] http://pad.lv/1372482
> 

(I'm no longer with Red Hat, so the jlayton@redhat.com address won't
reach me any longer...)

It looks like you probably just need to merge
dca1c8d17a2feae056f9e334ea75a462ae4cb52a into your kernel as well.

Cheers,
-- 
Jeff Layton <jlayton@samba.org>
