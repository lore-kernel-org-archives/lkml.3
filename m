Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3LTBjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:39:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55330 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab3LTBjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:39:21 -0500
X-IronPort-AV: E=Sophos;i="4.95,516,1384272000"; 
   d="scan'208";a="9294487"
Message-ID: <52B39FEB.8030308@cn.fujitsu.com>
Date: Fri, 20 Dec 2013 09:39:55 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: fix build error when disable audit
References: <1387420469-27665-1-git-send-email-gaofeng@cn.fujitsu.com> <52B25CA8.8090806@cn.fujitsu.com> <20131220011956.GA14944@madcap2.tricolour.ca>
In-Reply-To: <20131220011956.GA14944@madcap2.tricolour.ca>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 09:38:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 09:38:26
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 09:19 AM, Richard Guy Briggs wrote:
> On 13/12/19, Gao feng wrote:
>> On 12/19/2013 10:34 AM, Gao feng wrote:
>>> kernel/capability.c: In function ‘SYSC_capset’:
>>> kernel/capability.c:280:2: warning: passing argument 1 of ‘audit_log_capset’ makes integer from pointer without a cast [enabled by default]
>>>   audit_log_capset(new, current_cred());
>>>   ^
>>> In file included from kernel/capability.c:10:0:
>>> include/linux/audit.h:400:20: note: expected ‘pid_t’ but argument is of type ‘struct cred *’
>>>  static inline void audit_log_capset(pid_t pid, const struct cred *new,
>>>                     ^
>>> kernel/capability.c:280:2: error: too few arguments to function ‘audit_log_capset’
>>>   audit_log_capset(new, current_cred());
>>>   ^
>>> In file included from kernel/capability.c:10:0:
>>> include/linux/audit.h:400:20: note: declared here
>>>  static inline void audit_log_capset(pid_t pid, const struct cred *new,
>>>                     ^
>>> make[1]: *** [kernel/capability.o] Error 1
>>
>> BTW, bug introduced by commmit 26b81eb408c411d86c7cc93278fb88fbcd785f65
>> audit: Simplify and correct audit_log_capset
> 
> Yup, found it.  Thanks for the patch.  Since it isn't upstream yet, I
> may merge it and rebase for linux-next.
> 

thank you Richard, btw, do you have plan to push these changes to the linux-next?

