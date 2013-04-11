Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3DKELM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:11:12 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42348 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3DKELK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:11:10 -0400
X-Spam-Score: -100.8
Message-ID: <516637BB.90606@asianux.com>
Date: Thu, 11 Apr 2013 12:10:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: auditfilter: looping issue, memory leak if has
 2 or more AUDIT_FILTERKEYs
References: <51653645.90401@asianux.com> <51653C7A.6030405@asianux.com> <2119919725.12278128.1365628773876.JavaMail.root@redhat.com>
In-Reply-To: <2119919725.12278128.1365628773876.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月11日 05:19, Eric Paris wrote:
> ----- Original Message -----
> 
>> >   b. has an new issue for AUDIT_DIR:
>> >        after AUDIT_DIR succeed, it will set rule->tree.
>> >        next, the other case fail, then will call audit_free_rule.
>> >        but audit_free_rule will not free rule->tree.
> Definitely a couple of leaks here...
> 
> I'm seeing leaks on size 8, 64, and 128.
> 
> Al, what do you think?  Should I be calling audit_put_tree() in the error case if entry->tree != NULL?  The audit trees are some of the most complex code in the kernel I think.
> 
> 

  can we add it in audit_free_rule ?

  maybe like this:

@@ -75,6 +75,8 @@ static inline void audit_free_rule(struct audit_entry *e)
 	/* some rules don't have associated watches */
 	if (erule->watch)
 		audit_put_watch(erule->watch);
+	if (erule->tree)
+		audit_put_tree(erule->tree);
 	if (erule->fields)
 		for (i = 0; i < erule->field_count; i++) {
 			struct audit_field *f = &erule->fields[i];


  thanks.

  :-)

-- 
Chen Gang

Asianux Corporation
