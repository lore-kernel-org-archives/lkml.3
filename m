Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3JQR0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:26:51 -0400
Received: from smtp104.biz.mail.ne1.yahoo.com ([98.138.207.11]:24134 "HELO
	smtp104.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757987Ab3JQR0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:26:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CdRE04gVM1mOoyuBwCQXtaNJgCPnAz2IbSaKX3ykV5hzI_J
 .uPqY847fuYb1rcD1diiFqspX.GF3Q_47w8Zi8aG21Z.oKQnm38mWHU64GS1
 2Q87npX01Gs46sfA15AOaA2XutMEAbFHhMN0WUdbTvRn8FvTy4OCTGGHYKws
 PBgewem4FHvTeChUQdSriIulkm2MYrO_unFIP.8QDLTrYceuO1BXOsxzS7er
 W_XWE9rdUzRD_cLJozAgnX_NszI7gxnJxUXBP2KSgtRoAAg14iGje0R7eNqW
 RliKEZ3RKTlulBhzcgQCcuWUl0kSZKsh.GgDKcJbmUb6XRai7e22UmCpiSKh
 epEDzR5wfqSkjK2yJnrtUmnsjBxFIuxpGulfd3cfFu12NetMd_asQL_HjLdT
 wdLu5G6zFu696uaFy5JBAThkeFN.R2WdmaGp9xGhZ5bZZeF2WEJiFlyV8jxa
 Kn9dKehWB6X1E0Kg_aBlfar0tqcH2BMHGieDN19Iby9jPoU1QJgzgG30vyxy
 XaEzNMesGmcSEMr7e_L5lZHV_bAHgG1GF_B.yuHWVrfp.YwQfbt4jelZ206M
 H9P5E141hs.nrdx3NI6kM.m0FH5Uig_LcO2T_OjHTsAnng6m74rrxPUw-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.168.21.102 with )
        by smtp104.biz.mail.ne1.yahoo.com with SMTP; 17 Oct 2013 10:26:47 -0700 PDT
Message-ID: <52601DD8.7090308@schaufler-ca.com>
Date: Thu, 17 Oct 2013 10:26:48 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
References: <20130920203556.GA8726@www.outflux.net> <alpine.LRH.2.02.1310171858170.32257@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1310171858170.32257@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 1:02 AM, James Morris wrote:
> This seems like a regression in terms of separating mechanism and policy.  
>
> We have several access control systems available (SELinux, at least) which 
> can implement this functionality with existing mechanisms using dynamic 
> policy.

They said the same thing about Smack.

The problem there is that you have to buy into the entirety of
SELinux to implement a small bit of behavior. You have to write
a policy that takes every aspect of system behavior into account
when all you care about is loading restrictions on modules.

If you want all of SELinux you still have to define your problem
in a subject/object model. That may be possible, but in this
case at least it certainly ain't obvious.

> I'm concerned about the long term architectural impact of a proliferation 
> of arbitrary hard-coded security policies in the kernel.  I don't 
> understand the push in this direction, frankly.

The rationale is that lots of people doing little things is
likely to get us relevant security in a reasonable amount of time.
The existing LSMs reflect 20th century technologies and use cases.
They are fine for multi-user timesharing systems. We need to move
forward to support networked gaming, phones, tablets and toasters.

>
> On Fri, 20 Sep 2013, Kees Cook wrote:
>
>> ...
>> -- 
>> 1.7.9.5
>>
>>
>> -- 
>> Kees Cook
>> Chrome OS Security
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

