Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaEMN1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:27:52 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56027 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbaEMN1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:27:51 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: mmarek@suse.cz, akpm@linux-foundation.org, prarit@redhat.com,
        michael.opdenacker@free-electrons.com, tkhai@yandex.ru,
        nasa4836@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/tags.sh: add regular expression replacement pattern for memcg
Date: Tue, 13 May 2014 21:26:53 +0800
Message-Id: <1399987613-18154-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Prarit,

>> Currently, no regular expression replacement pattern for PageCgroug*
>
>^^^ *Cgroup*
 
  Sorry for the typo, fixed. Thanks.

>> defined, which causes quite a few pain while reading code. Just get 
>> rid of it. 
>>
>
>IMO the patch looks fine but can you fixup your changelog a little bit?  I think
>the new "standard" has become an explanation and example of the problem, an
>explanation of what is wrong, and what you did to fix it (including an example
>of output if possible).  That way we know what was changed and why :)

 Yep, you are right. Rewrote the wording.
 Would you mind signing your Reviewed-by if it is Ok? Thanks.

---<8---
Currently, while using ctags to read code, we would get stumbled on
PageCgroup* symbols: no definition found. And it is quite dull to
manually dig it out.

This patch adds regular expression replacement pattern for such symbols,
like what have done for the PageXXX flag. It will teach ctags to find
out the definition for us.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 scripts/tags.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index f2c5b00..7d3ebfe 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -187,6 +187,10 @@ exuberant()
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
 	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
+	--regex-c++='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'		\
+	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
+	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
+	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
 	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
 	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
 	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
@@ -244,6 +248,10 @@ emacs()
 	--regex='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
 	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
+	--regex='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'	\
+	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
+	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
+	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
 	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'
-- 
2.0.0-rc1

