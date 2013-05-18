Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3ERLGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 07:06:16 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:53463 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3ERLGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 07:06:14 -0400
MIME-Version: 1.0
In-Reply-To: <5195C39F.9010101@asianux.com>
References: <5195C39F.9010101@asianux.com>
Date: Sat, 18 May 2013 19:06:13 +0800
Message-ID: <CACVXFVNiWwiXtubJSbE3z6-AyxcOBgyvhn+2diHyi5Nyj4XYeg@mail.gmail.com>
Subject: Re: [Consult] Why need we call device_remove_file() firstly before
 call device_unregister() ?
From: Ming Lei <tom.leiming@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, May 17, 2013 at 1:43 PM, Chen Gang <gang.chen@asianux.com> wrote:
> Hello All:
>
> I searched 'arch/*' and 'drivers/*' sub-directory, all of them are 'obey
> this rule', even in device_unregister() itself, it also firstly calls
> device_remove_file(), then call kobject_del().
>
> But after read the related code (fs/sysfs/*, drivers/base/core.c), it
> seems kobject_del() -> sysfs_remove_dir() which will release all related
> things (can instead of device_remove_file()).
>
> So in fact, we need not call device_remove_file() before call
> device_unregister(), is it correct ?

Looks it is correct but it is a bit implicit.

Thanks,
-- 
Ming Lei
