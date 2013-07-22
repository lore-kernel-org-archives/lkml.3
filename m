Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab3GVVbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:31:24 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:64751 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab3GVVbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130722212822.GB16776@mtj.dyndns.org>
References: <51E53300.6010000@cogentembedded.com>
	<1374041439-34122-1-git-send-email-xtfeng@gmail.com>
	<20130722212822.GB16776@mtj.dyndns.org>
Date: Tue, 23 Jul 2013 05:31:21 +0800
Message-ID: <CAJn8CcFE8v8PVkxdsfwi4=f=pVjK6R6uLAs68CtCmv2GU+7b4g@mail.gmail.com>
Subject: Re: [PATCH] AHCI: fix Null pointer dereference in achi_host_active()
From: Xiaotian Feng <xtfeng@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 5:28 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Xiaotian.
>
> Thanks for the fix.  A couple comments below.
>
> On Wed, Jul 17, 2013 at 02:10:39PM +0800, Xiaotian Feng wrote:
>>       for (i = 0; i < host->n_ports; i++) {
>>               struct ahci_port_priv *pp = host->ports[i]->private_data;
>> +             const char *desc;
>>
>> +             if (ata_port_is_dummy(host->ports[i]))
>> +                     desc = dev_driver_string(host->dev);
>> +             else
>> +                     desc = pp->irq_desc;
>
> I think it'd be better to branch on pp.  ie. do "if (pp) desc =
> pp->... " instead and then add a comment saying "pp is NULL for
> dummies".
>

Okay, I'll update v2 patch, thanks :)

> Thanks!
>
> --
> tejun
