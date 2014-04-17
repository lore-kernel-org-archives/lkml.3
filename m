Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaDQHTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:19:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48466 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaDQHTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:19:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
References: <20140417151245.467efa8bd8d084277fd471c9@canb.auug.org.au>
Date: Thu, 17 Apr 2014 00:18:44 -0700
In-Reply-To: <20140417151245.467efa8bd8d084277fd471c9@canb.auug.org.au>
	(Stephen Rothwell's message of "Thu, 17 Apr 2014 15:12:45 +1000")
Message-ID: <87bnw0ctkb.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+GxDulNo2Vr6DTkCSkfAtsKWPyT9CJ6d0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4950]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: build failure after merge of the userns tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> After merging the userns tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/namespace.c: In function 'new_mountpoint':
> fs/namespace.c:725:9: error: implicit declaration of function 'hash' [-Werror=implicit-function-declaration]
>   struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
>          ^
> fs/namespace.c:725:28: warning: initialization from incompatible pointer type [enabled by default]
>   struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
>                             ^
> fs/namespace.c:741:2: warning: passing argument 2 of 'hlist_add_head' from incompatible pointer type [enabled by default]
>   hlist_add_head(&mp->m_hash, chain);
>   ^
> In file included from include/linux/signal.h:4:0,
>                  from include/linux/syscalls.h:72,
>                  from fs/namespace.c:11:
> include/linux/list.h:637:20: note: expected 'struct hlist_head *' but argument is of type 'struct list_head *'
>  static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
>                     ^
>
> So clearly my merge conflict resolution was not sufficient.
>
> I will just drop the userns tree for today.  Please give me some help
> with the resolutions - or fix this stuff up yourselves.

You had this exact conflict succesfully resolved yesterday.  Sigh.

Line 725 of fs/namespace.c: Simply need to read.
	struct hlist_head *chain = mp_hash(dentry);

Eric

