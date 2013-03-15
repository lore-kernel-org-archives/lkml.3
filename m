Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3CORqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:46:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46593 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3CORqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:46:06 -0400
Date: Fri, 15 Mar 2013 18:45:50 +0100
From: Anisse Astier <anisse@astier.eu>
To: linux-kernel@vger.kernel.org
Cc: zhenzhong.duan@oracle.com, akpm@linux-foundation.org, khali@linux-fr.org,
        Feng Jin <joe.jin@oracle.com>
Subject: Re: [PATCH 1/2] Check dmi version when get system uuid
Message-ID: <20130315184550.2255e71b@serenity>
In-Reply-To: <500FD2D9.4050007@oracle.com>
References: <500FD2D9.4050007@oracle.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012 19:04:57 +0800, "zhenzhong.duan" <zhenzhong.duan@oracle.com> wrote :

> As of version 2.6 of the SMBIOS specification, the first 3
> fields of the UUID are supposed to be encoded on little-endian.
> 
> Also a minor fix to match variable meaning and mute checkpatch.pl
> 

I'm late to the party, as this patch went into 3.8, mimicking a patch
sent in 2011:
https://lkml.org/lkml/2011/1/19/260

Only problem: it breaks the ABI. By changing the value of the DMI UUID
previously sent by the kernel, any application relying on this UUID is
likely to break with 3.8.

I don't know if I should be happy I finally can drop this patch from my 
tree, or sad that a different process let it through.

Regards,

Anisse
