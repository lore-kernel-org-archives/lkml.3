Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbbAMWpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:45:14 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:45576 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbAMWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:45:12 -0500
MIME-Version: 1.0
In-Reply-To: <1737170.75ul4v7eON@sifl>
References: <1421016270-25547-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1737170.75ul4v7eON@sifl>
Date: Tue, 13 Jan 2015 23:45:09 +0100
Message-ID: <CAKXHbyP5nay1XBCk7tkH_o2==Vu16aWQOG949T-xoffXse7Fsw@mail.gmail.com>
Subject: Re: [PATCH] selinux: ss: mls: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Dave Jones <davej@redhat.com>,
        selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-12 21:29 GMT+01:00 Paul Moore <paul@paul-moore.com>:
> On Sunday, January 11, 2015 11:44:30 PM Rickard Strandqvist wrote:
>> Remove the function mls_import_netlbl_cat() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called
>> cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  security/selinux/ss/mls.c |   38 --------------------------------------
>>  security/selinux/ss/mls.h |    7 -------
>>  2 files changed, 45 deletions(-)
>
> Thanks for bringing this up and sending a patch.
>
> However, what we should probably do is take the existing MLS category code in
> security_netlbl_secattr_to_sid() and reconcile it with the code in
> mls_import_netlbl_cat() and convert security_netlbl_secattr_to_sid() to using
> the mls_import_netlbl_cat() function.
>
> Is that something you want to try?  If not, let me know and we'll work on it.
>
>> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
>> index d307b37..c01c755 100644
>> --- a/security/selinux/ss/mls.c
>> +++ b/security/selinux/ss/mls.c
>> @@ -631,42 +631,4 @@ int mls_export_netlbl_cat(struct context *context,
>>
>>       return rc;
>>  }
>> -
>> -/**
>> - * mls_import_netlbl_cat - Import the MLS categories from NetLabel
>> - * @context: the security context
>> - * @secattr: the NetLabel security attributes
>> - *
>> - * Description:
>> - * Copy the NetLabel security attributes into the SELinux context; since
>> the - * NetLabel security attribute only contains a single MLS category use
>> it for - * both the low and high categories of the context.  Returns zero
>> on success, - * negative values on failure.
>> - *
>> - */
>> -int mls_import_netlbl_cat(struct context *context,
>> -                       struct netlbl_lsm_secattr *secattr)
>> -{
>> -     int rc;
>> -
>> -     if (!policydb.mls_enabled)
>> -             return 0;
>> -
>> -     rc = ebitmap_netlbl_import(&context->range.level[0].cat,
>> -                                secattr->attr.mls.cat);
>> -     if (rc != 0)
>> -             goto import_netlbl_cat_failure;
>> -
>> -     rc = ebitmap_cpy(&context->range.level[1].cat,
>> -                      &context->range.level[0].cat);
>> -     if (rc != 0)
>> -             goto import_netlbl_cat_failure;
>> -
>> -     return 0;
>> -
>> -import_netlbl_cat_failure:
>> -     ebitmap_destroy(&context->range.level[0].cat);
>> -     ebitmap_destroy(&context->range.level[1].cat);
>> -     return rc;
>> -}
>>  #endif /* CONFIG_NETLABEL */
>> diff --git a/security/selinux/ss/mls.h b/security/selinux/ss/mls.h
>> index e4369e3..11d3c8f 100644
>> --- a/security/selinux/ss/mls.h
>> +++ b/security/selinux/ss/mls.h
>> @@ -62,8 +62,6 @@ void mls_import_netlbl_lvl(struct context *context,
>>                          struct netlbl_lsm_secattr *secattr);
>>  int mls_export_netlbl_cat(struct context *context,
>>                         struct netlbl_lsm_secattr *secattr);
>> -int mls_import_netlbl_cat(struct context *context,
>> -                       struct netlbl_lsm_secattr *secattr);
>>  #else
>>  static inline void mls_export_netlbl_lvl(struct context *context,
>>                                        struct netlbl_lsm_secattr *secattr)
>> @@ -80,11 +78,6 @@ static inline int mls_export_netlbl_cat(struct context
>> *context, {
>>       return -ENOMEM;
>>  }
>> -static inline int mls_import_netlbl_cat(struct context *context,
>> -                                     struct netlbl_lsm_secattr *secattr)
>> -{
>> -     return -ENOMEM;
>> -}
>>  #endif
>>
>>  #endif       /* _SS_MLS_H */
>
> --
> paul moore
> www.paul-moore.com
>

Hi Paul

Thank you, yes it would be nice to do something for real :)
But will probably need a little more time than tonight for it, if it's
OK to wait until the weekend.


Kind regards
Rickard Strandqvist
