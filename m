Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3EQFov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 01:44:51 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54537 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3EQFou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 01:44:50 -0400
X-Spam-Score: -100.8
Message-ID: <5195C39F.9010101@asianux.com>
Date: Fri, 17 May 2013 13:43:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Consult] Why need we call device_remove_file() firstly before call
 device_unregister() ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All:

I searched 'arch/*' and 'drivers/*' sub-directory, all of them are 'obey
this rule', even in device_unregister() itself, it also firstly calls
device_remove_file(), then call kobject_del().

But after read the related code (fs/sysfs/*, drivers/base/core.c), it
seems kobject_del() -> sysfs_remove_dir() which will release all related
things (can instead of device_remove_file()).

So in fact, we need not call device_remove_file() before call
device_unregister(), is it correct ?


Welcome any member to give a suggestion or completion about it, thanks.


Thanks.
-- 
Chen Gang

Asianux Corporation
