Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaEUUbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:31:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55742 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaEUUbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:31:16 -0400
Date: Wed, 21 May 2014 16:31:13 -0400 (EDT)
Message-Id: <20140521.163113.383854871907102866.davem@davemloft.net>
To: cwang@twopensource.com
Cc: milos.vyletel@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net-next] net: ipv6: trigger action when setting
 conf.all sysctls
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHA+R7PaM4c6TmUtTLDAGnBUmRKE7=vnsjm67i=rmNebZvacVw@mail.gmail.com>
References: <1400519372-5703-1-git-send-email-milos.vyletel@gmail.com>
	<CAHA+R7PaM4c6TmUtTLDAGnBUmRKE7=vnsjm67i=rmNebZvacVw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 May 2014 13:31:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <cwang@twopensource.com>
Date: Wed, 21 May 2014 10:35:17 -0700

> On Mon, May 19, 2014 at 10:09 AM, Milos Vyletel <milos.vyletel@gmail.com> wrote:
>> As it is right now most of these tunables don't do anything - they don't
>> set any interface specific settings to the desired value and they don't
>> take precedence before device specific settings in most cases.
>>
>> Documentation/networking/ip-sysctl.txt defines them to be:
>> conf/all/*:
>>         Change all the interface-specific settings.
>>
>> but that is not really the case.
>>
> 
> I don't think it's a good idea, it enforces interface specific changes.
> 
> You need to mimic what IPv4 conf does (if it hasn't done yet), something
> like below:
> 
> #define IN_DEV_MAXCONF(in_dev, attr) \
>         (max(IPV4_DEVCONF_ALL(dev_net(in_dev->dev), attr), \
>              IN_DEV_CONF_GET((in_dev), attr)))

Agreed.
