Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3BVOjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:39:02 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35273 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab3BVOi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:38:59 -0500
Date: Fri, 22 Feb 2013 15:38:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: edac: NULL deref when handling sysfs write
Message-ID: <20130222143852.GF25473@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sasha Levin <sasha.levin@oracle.com>, dougthompson@xmission.com,
	linux-edac@vger.kernel.org, Dave Jones <davej@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <512780B0.9040508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512780B0.9040508@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 09:29:04AM -0500, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel
> I've stumbled on the following spew:
> 
> 
> [ 2060.023557] Invalid bank value!

You're injecting into an invalid bank.

> [ 2060.029076] [Hardware Error]: MC0 Error:

This looks like a second write to the same sysfs file which passes the
first.

For now, do

rmmod mce_amd_inj

before running trinity.

This module needs to get converted to debugfs (I have patches) anyway.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
