Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3C1Hoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:44:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3C1Hoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:44:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Generic syscall ABI support
Date: Thu, 28 Mar 2013 07:44:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1364440182.2289.45.camel@leyfoon-vm> <5153D698.6010102@zytor.com>
In-Reply-To: <5153D698.6010102@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303280744.27477.arnd@arndb.de>
X-Provags-ID: V02:K0:eEIGbrPDJp3zUB8qUAHUaQrCT2LUXbPM/NPRUuoEIpy
 mT0yLHNc/LCLqcQazEdWgzdU1wA9+6LpX3PwR8kN5Ve1mZ+skS
 hPcdmyRNXZ8O9DGLAAD57/52gpb3magnxZqJ5DzcBuENAWjsEH
 Mq1XFPjX4uHRrzoxV0QXyAlTTlNklWOkXKcIzBXdbbvS7z4PfZ
 TLRLU2k4sF0T4STE1+jGqNjOEljQmWyDwWU35YnZBz/oIfB0EN
 YkHPAWWw8U2EEPSsWTi2cLaC7NE0nZWrMqfT9ciQrmxqFy2O9+
 qFX3Iq0VQgtjqnA517fXwBqA5wu3k//FL70L+SFnVnzv1cUyk3
 6pWaL/E7FdBmxxU/ZQIY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, H. Peter Anvin wrote:
> On 03/27/2013 08:09 PM, Ley Foon Tan wrote:

> > The question is, is it a requirement for new arch to support generic
> > syscall ABI when upstreaming? Can we upstream a non-generic syscall ABI
> > first and migrate to generic syscall ABI in future?
> > Thanks.
>
> In general, you should use the generic ABI for a new port unless you
> have very strong and convincing reasons not to.

Yes, absolutely. What a couple of the previous architectures have done is
to keep out of tree patches for their old ABI for a while, and to submit
only code that follows the generic ABI upstream. Usually it doesn't take
long for users to migrate to a new user space after that, but it gives
people a migration strategy. Normally you have other patches that are
required on top of the stuff that is already upstream while you are
getting everything merged, so this is not much different to a device
driver that needs to get rewritten to adapt to a new kernel subsystem.

	Arnd
