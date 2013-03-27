Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3C0MFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:05:41 -0400
Received: from forward18.mail.yandex.net ([95.108.253.143]:34247 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3C0MFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:05:39 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Mar 2013 08:05:39 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Michal Marek <mmarek@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20130326213532.GB22359@pobox.suse.cz>
References: <1810321364036300@web2f.yandex.ru> <20130326213532.GB22359@pobox.suse.cz>
Subject: Re: [PATCH] scripts/tags.sh: Add magic for OFFSET and DEFINE
MIME-Version: 1.0
Message-Id: <1897121364385591@web7g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 27 Mar 2013 15:59:51 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



27.03.2013, 01:35, "Michal Marek" <mmarek@suse.cz>:
> On Sat, Mar 23, 2013 at 02:58:20PM +0400, Kirill Tkhai wrote:
>
>> šAdd rules for definitions which is generally used in asm-offsets files.
>>
>> šSigned-off-by: Kirill V Tkhai <tkhai@yandex.ru>
>> šCC: Michal Marek <mmarek@suse.cz>
>> šCC: Andrew Morton <akpm@linux-foundation.org>
>> š---
>> ššscripts/tags.sh | ššš4 +++-
>> šš1 file changed, 3 insertions(+), 1 deletion(-)
>> šdiff --git a/scripts/tags.sh b/scripts/tags.sh
>> šindex 26a87e6..74f02e4 100755
>> š--- a/scripts/tags.sh
>> š+++ b/scripts/tags.sh
>> š@@ -199,7 +199,9 @@ exuberant()
>> šššššššššš--regex-c='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
>> šššššššššš--regex-c='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/' \
>> šššššššššš--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/' \
>> š- --regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
>> š+ --regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/' \
>> š+ --regex-c='/(^\s)OFFSET\((\w*)/\2/v/' \
>> š+ --regex-c='/(^\s)DEFINE\((\w*)/\2/v/'
>
> The macro definitions in the asm-offsets.h file are ammended with a
> comment explaining what the value actually means. So you see both the
> value and the semantic of the macro:
>
> #define TI_flags 16 /* offsetof(struct thread_info, flags) ššššš# */
>
> By jumping to the asm-offset.c file instead, you would get only a subset
> of that information.
>
> OFFSET(TI_flags, thread_info, flags);
>
> Unless I'm missing something, I don't think that this patch improves
> much.

This patch does not annul definitions in asm-offsets.h. They stay still on their places.
It adds OFFSETs and DEFINEs from asm-offsets.c files.

When kernel is not precompiled you do not have asm-offsets.h and you are not
able to see what is the place offsets are defined for yor architecture.

Also, you are not able to look at other architectures because they do not have
precompiled asm-offsets.h.

I use ALLSOURCE_ARCHS=`ls arch/ | grep -v Kconfig` make tags to generate tags.
I thing some people do the same and sometimes they need offsets for another
architectures.

Kirill
