Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3HUEQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:16:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39058 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3HUEQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:16:30 -0400
X-Spam-Score: -101.0
Message-ID: <52143EE0.3040604@asianux.com>
Date: Wed, 21 Aug 2013 12:15:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: user_namespace: always set the return parameter
 'new_cred' when call unshare_userns() successfully.
References: <5212DA37.1090101@asianux.com> <20130820141032.GA4766@sergelap> <20130820143722.GA12953@redhat.com>
In-Reply-To: <20130820143722.GA12953@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:37 PM, Oleg Nesterov wrote:
> On 08/20, Serge Hallyn wrote:
>>
>> Quoting Chen Gang (gang.chen@asianux.com):
>>> When unshare_userns() succeed, recommend to always set the return
>>> parameter which may be used by caller.
>>>
>>> The caller has rights to call it with 'new_cred' uninitialized, if
>>> succeed, the caller can assume the 'new_cred' has been initialized.
>>
>> But the only existing caller (sys_unshare) does in fact initialize it to
>> NULL.  So while this patch does no harm, is it necessary?
> 
> Agreed.
> 
> Plus, with this patch unshare_userns() becomes "inconsistent" compared
> to other unshare_ helpers.
> 
> Oleg.
> 
> 
> 

Hmm... for static functions, they don't need, but for extern functions,
recommend to do so.


For "unshare_ helpers", I find 3 extern functions:

  unshare_files() which already set value.
  unshare_userns() and unshare_nsproxy_namespaces() which not set.

In my opinion, recommend to always set the return parameter when
succeed, for the 2 left extern functions.


Thanks.
-- 
Chen Gang
