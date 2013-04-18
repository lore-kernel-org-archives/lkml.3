Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935995Ab3DRBU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 21:20:28 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58551 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935765Ab3DRBUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 21:20:25 -0400
Message-ID: <516F4A28.2050806@gmail.com>
Date: Thu, 18 Apr 2013 09:19:36 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Chen Gang <gang.chen@asianux.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: audit_tree: resource management: need put_tree
 and goto Err when failure occures
References: <516790ED.6060202@asianux.com> <516CFF2C.7010509@asianux.com> <516E1F32.6010009@asianux.com> <20130417130739.03fb8d9ccb908afc0a1db861@linux-foundation.org>
In-Reply-To: <20130417130739.03fb8d9ccb908afc0a1db861@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月18日 04:07, Andrew Morton wrote:
> On Wed, 17 Apr 2013 12:04:02 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> 
>> >   since "normally audit_add_tree_rule() will free it on failure",
>> >   need free it completely, when failure occures.
>> > 
>> >     need additional put_tree before return, since get_tree was called.
>> >     always need goto error processing area for list_del_init.
> Isn't that get_tree() in audit_add_tree_rule() simply unneeded?  In
> other words, is this patch correct:
> 

  excuse me:
    I am not quite familiar with it, and also have to do another things.
    so I have to spend additional time resource to make sure about it.

  is it ok ?
    I should make sure about it within this week (2013-04-21)
    I should finish related test (if need), within next week (2013-4-28)

  if have additional suggestions or completions, please reply.
    (if no reply, I will follow the time point above)

  thanks.

gchen.


> --- a/kernel/audit_tree.c~a
> +++ a/kernel/audit_tree.c
> @@ -682,7 +682,6 @@ int audit_add_tree_rule(struct audit_kru
>  		goto Err;
>  	}
>  
> -	get_tree(tree);
>  	err = iterate_mounts(tag_mount, tree, mnt);
>  	drop_collected_mounts(mnt);
>  
> @@ -703,7 +702,6 @@ int audit_add_tree_rule(struct audit_kru
>  		return -ENOENT;
>  	}
>  	rule->tree = tree;
> -	put_tree(tree);
>  
>  	return 0;
>  Err:
> _
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Chen Gang

Flying Transformer
