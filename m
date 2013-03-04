Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3CDDcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:32:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3CDDcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:32:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 1/1] drivers/misc: Add Altera System ID driver
Date: Mon, 4 Mar 2013 03:32:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <1362366697-2768-1-git-send-email-lftan@altera.com>
In-Reply-To: <1362366697-2768-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303040332.20076.arnd@arndb.de>
X-Provags-ID: V02:K0:v/Ko/zRl0P4bwntLaokedZqBR1vWN++gVQGRoxM5PVz
 76/v3Ep+flLDUQhRVj2HX1t0oOhnLY5lSNhaOjlGyj7gGnWcdY
 PdqNEc6amJQIfRYt4YksDlxqzeGfhSb69sqaNqOmtCxlJqil6F
 WLHlAI9/opzPQaCnDAavZCkRiLEvdEqM6zOdwQhSA0bacSP0Vv
 ZUlluR1OoDhs/n6oZ9FBR2LEJ1zQGzZ+xG9jKeacjh3uvQgKpE
 E9lgo24WJTGLOjyGo1kHdL/QE8QwqLBbZ9SU8T/0Z1YWjlKiND
 ZrWdZdTVixuYh7kfVHyr8QjQa0aE/8pC144G8dYCL4IiFKevUk
 tczfJ2JQQZZtJWIaHvo8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 March 2013, Ley Foon Tan wrote:
> This patch is to add Altera System ID driver.
> User can obtain the system ID and timestamp of the system by
> reading the sysfs entry.
> 
> Usage:
> cat /sys/bus/platform/devices/[addr].sysid/sysid/id
> cat /sys/bus/platform/devices/[addr].sysid/sysid/timestamp
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>

All sysfs files need documentation in Documentation/ABI/.

This driver looks like it should instead be using the infrastructure we
have for identifying an SoC in drivers/base/soc.c, which is currently
only used by the ARM u8500 platform but was introduced as a generic
interface for this a while ago.

	Arnd
