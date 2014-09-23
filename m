Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaIWTJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:09:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaIWTJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:09:38 -0400
Message-ID: <5421C563.8070304@canonical.com>
Date: Tue, 23 Sep 2014 15:09:23 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: jlayton@redhat.com
CC: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>
Subject: [Regression]  cifs: sanity check length of data to send before sending
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

A kernel bug report was opened against Ubuntu [0].  It was found that
reverting the following commit resolved this bug:


commit a26054d184763969a411e3939fe243516715ff59
Author: Jeff Layton <jlayton@redhat.com>
Date:   Fri Feb 14 07:21:00 2014 -0500

    cifs: sanity check length of data to send before sending

      
The regression was introduced as of v3.14-rc7.

It appears the patch may be doing what it is supposed to, since the
send_length != smb_buf_length:
send_length=72
and
smb_buf_length=2164260932

However, without this check and WARN/return of -EIO the samba
connections still work correctly.

I was hoping to get your feedback, since you are the patch author.  Do
you think gathering any additional data will help diagnose this issue,
or would it be best to submit a revert request?
    
Thanks,
    
Joe

[0] http://pad.lv/1372482

