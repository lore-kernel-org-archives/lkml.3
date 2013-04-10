Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936167Ab3DJVdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:33:03 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:37447 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934994Ab3DJVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:33:01 -0400
Date: Wed, 10 Apr 2013 17:32:58 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <803399362.12318964.1365629578422.JavaMail.root@redhat.com>
In-Reply-To: <51653EC2.5030107@asianux.com>
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <51653EC2.5030107@asianux.com>
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: kernel: auditfilter: looping issue, memory leak if has 2 or more AUDIT_FILTERKEYs
Thread-Index: LrNKGc+2Vw/Tect34J/L1mAI8sjCQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> 
>   also for function audit_list:
>     when call audit_make_reply fails (will return NULL).
>     we need free all its related variables instead of only kfree rull.
>       (such as call autit_free_rule)
> 
>   please help check, thanks.

audit_free_rule() takes a struct audit_entry, not an audit_rule.  struct audit_rule does not have additional things which need to be freed...
