Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160Ab3DJVTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:19:38 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:36762 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762176Ab3DJVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:19:36 -0400
Date: Wed, 10 Apr 2013 17:19:33 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Message-ID: <2119919725.12278128.1365628773876.JavaMail.root@redhat.com>
In-Reply-To: <51653C7A.6030405@asianux.com>
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com>
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: kernel: auditfilter: looping issue, memory leak if has 2 or more AUDIT_FILTERKEYs
Thread-Index: ebZgkmbTD6XhkQheVQ+96n7yrHv23A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

>   b. has an new issue for AUDIT_DIR:
>        after AUDIT_DIR succeed, it will set rule->tree.
>        next, the other case fail, then will call audit_free_rule.
>        but audit_free_rule will not free rule->tree.

Definitely a couple of leaks here...

I'm seeing leaks on size 8, 64, and 128.

Al, what do you think?  Should I be calling audit_put_tree() in the error case if entry->tree != NULL?  The audit trees are some of the most complex code in the kernel I think.
