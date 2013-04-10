Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab3DJU3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:29:46 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60785 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab3DJU3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:29:45 -0400
Date: Wed, 10 Apr 2013 16:29:41 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Message-ID: <797985275.12108128.1365625781813.JavaMail.root@redhat.com>
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
Thread-Index: kovY+PBeP5cQTgvPAgUIVOvp//mUBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> 
> 
> in another function: audit_data_to_entry:
> 
>   a. has the same issue for case AUDIT_WATCH.

You are saying if there were 2 of them it will leak the old one?  No.  If you have 2 AUDIT_WATCH entries the first one will set entry->rule->watch and the second will bomb with EINVAL in audit_to_watch()
