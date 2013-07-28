Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3G1Sqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:46:51 -0400
Received: from smtp106.biz.mail.gq1.yahoo.com ([98.137.12.181]:43743 "HELO
	smtp106.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750932Ab3G1Sqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:46:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9y92h0gVM1ktL7vEQl8p0tlEYX7ioUxepqzJNQvvNSq2CVG
 .kDh6dd4JAppVleyazwrENs5mtq5pZ.PKYlRNeEhsO501Br8EgJWnOxo3qR7
 Z2lJCigc2av1QnCURAWxqvWKVMUtB8zbWCJJ88Tmi4qP7513ev2L9ghoy9KQ
 ho2HJsIq17TM.AlTW9sFcEmkzVb3MSyaG543rjS_ZMLwk8YZE8dEQhRupe80
 HWpAIrAeDWDWz.9gQF43PtokP423gJJva8MmX1SXOzLN40fXNUSw6sFmqfy2
 Qm4xmQMyYviaGTXFYspsnEfBm.rrNPNNwuDetj_xgV3y057GXBgY2tW9BAD1
 0QPzPzjfiZxwlCpPNDcj0h8FBDkYj0rnLh4uk_biTVkiu7GS6G.KEgeYmpYs
 5SXJnnB7C.dIVy_S5b_YoLLcID5Rn2GPUrBahMoQC4By9vPvz83s0cG_2.RF
 iDoaWdLN0IvI_BJb9K1sV6MZEXIdCeMMJ4jCOqV7itROLiFi7NEMx37B.JV_
 6fF7BhjvBOlBrnEPfMsVZr5YHPmacLNAesrSi3ANLRofDOnk0s2e381.5Rzh
 h9hP8NZl94IOiLi1c0caFv9LoBybqLmyM7fjfmlGclYIcHxn1v.nGkJFne_r
 xmVxo6so3FP9WqhoakWREhushQQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp106.biz.mail.gq1.yahoo.com with SMTP; 28 Jul 2013 18:46:47 +0000 UTC
Message-ID: <51F56716.8060707@schaufler-ca.com>
Date: Sun, 28 Jul 2013 11:46:46 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v14 6/6] LSM: Multiple LSM Documentation and cleanup
References: <51F16CFB.6040603@schaufler-ca.com> <51F16F3E.4040608@schaufler-ca.com> <51F3036D.3070900@infradead.org>
In-Reply-To: <51F3036D.3070900@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/2013 4:17 PM, Randy Dunlap wrote:
> On 07/25/13 11:32, Casey Schaufler wrote:
>> Subject: [PATCH v14 6/6] LSM: Multiple LSM Documentation and cleanup
>>
>> Add documentation and remove the obsolete capability LSM.
>> Clean up some comments in security.h
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>
>> ---
>>  Documentation/security/LSM.txt |   56 +-
>>  include/linux/security.h       |   48 +-
>>  security/Makefile              |    1 -
>>  security/capability.c          | 1106 ----------------------------------------
>>  4 files changed, 77 insertions(+), 1134 deletions(-)
>>
>> diff --git a/Documentation/security/LSM.txt b/Documentation/security/LSM.txt
>> index c335a76..69cf466 100644
>> --- a/Documentation/security/LSM.txt
>> +++ b/Documentation/security/LSM.txt
>> @@ -7,20 +7,56 @@ various security checks to be hooked by new kernel extensions. The name
>>  loadable kernel modules. Instead, they are selectable at build-time via
>>  CONFIG_DEFAULT_SECURITY and can be overridden at boot-time via the
>>  "security=..." kernel command line argument, in the case where multiple
>> -LSMs were built into a given kernel.
>> +LSMs were built into a given kernel. The names of the active LSMs
>> +can be read from /sys/kernel/security/lsm.
>> +
>> +Both CONFIG_DEFAULT_SECURITY and the "security=" option take a comma
>> +separated list of LSM names. The LSM hooks are invoked in the order
>> +specified. All hooks provided are invoked regardless of the outcome
>> +of preceding hooks. Hooks that return success or failure results
>> +return success if all of the LSM provided hooks succeed and the error
>> +code of the last failing hook on error.
>> +
>> +Information from an LSM can come in one of two forms. The raw data
>> +used by the LSM is typically the preferred form. SELinux contexts and
>> +Smack labels are examples of raw LSM data. If the data from multiple
>> +LSMs is presented together it will be in the form:
>> +
>> +	lsmname='value'[lsmname='value']...
> no commas? just (made up example):
>
> 	smack='label'selinux='notstrict'

That's correct. No commas. Because all values are quoted commas
are unnecessary. If I want the SELinux portion of a context I can call

	sscanf(source, "selinux='%[^']'", result);

and comma separation helps not a bit.

>> +
>> +Interfaces that accept LSM data as input accept this format as well,
>> +passing only the relevant portion of the data to each LSM.
>> +
>> +The /proc filesystem attribute interface supports files from a time
>> +when only one LSM could be used at a time. CONFIG_PRESENT_SECURITY
>> +defines which LSM uses these interfaces. The name of this LSM can be
>> +read from /sys/kernel/security/present. There are also LSM identified
>> +interfaces which should be used in preference to the undifferentiated
>> +interfaces. The attribute interface "context" always provides the
>> +data from all LSMs that maintain it in the lsmname='value' format.
>> +
>> +The three networking mechanisms supporting LSM attributes are
>> +restricted to providing those attributes for a single LSM each.
>> +CONFIG_SECMARK_LSM specifies which LSM will provide hooks for the
>> +secmark mechanism. CONFIG_NETLABEL_LSM specifies which LSM hooks
>> +are used by NetLabel to provide IPv4 CIPSO headers. CONFIG_XFRM_LSM
>> +specifies the LSM providing xfrm hooks. CONFIG_PEERSEC_LSM allows
>> +for either a specific LSM to provide data with SO_PEERSEC or for
>> +all LSMs that provide data to do so.
>> +
>> +The Linux capabilities system is used in conjunction with any LSMs.
>> +LSM hooks are called after the capability checks in most cases,
>                         ^^^^^
>> +but after in a small number of cases. All LSM hooks need to be aware
>        ^^^^^
>
>        one of these 'after's should be 'before' ??

Yup. The latter should in fact be "before".

>> +of the potential interactions with the capability system. For more
>> +details on capabilities, see capabilities(7) in the Linux man-pages
>> +project.
>>  
>>  The primary users of the LSM interface are Mandatory Access Control
>>  (MAC) extensions which provide a comprehensive security policy. Examples
>>  include SELinux, Smack, Tomoyo, and AppArmor. In addition to the larger
>> -MAC extensions, other extensions can be built using the LSM to provide
>> -specific changes to system operation when these tweaks are not available
>> -in the core functionality of Linux itself.
>> -
>> -Without a specific LSM built into the kernel, the default LSM will be the
>> -Linux capabilities system. Most LSMs choose to extend the capabilities
>> -system, building their checks on top of the defined capability hooks.
>> -For more details on capabilities, see capabilities(7) in the Linux
>> -man-pages project.
>> +MAC extensions, other extensions such as Yama can be built using the LSM
>> +to provide specific changes to system operation when these tweaks are not
>> +available in the core functionality of Linux itself.
>>  
>>  Based on http://kerneltrap.org/Linux/Documenting_Security_Module_Intent,
>>  a new LSM is accepted into the kernel when its intent (a description of
>>

