Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaFLGtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:49:08 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39350 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaFLGtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:49:06 -0400
Date: Wed, 11 Jun 2014 23:49:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yongtaek Lee <ytk.lee@samsung.com>
cc: rydberg@euromail.se, dmitry.torokhov@gmail.com, daniels@collabora.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - Fix incorrect kfree of err_free_client
 after vzalloc
In-Reply-To: <1402537537-17945-1-git-send-email-ytk.lee@samsung.com>
Message-ID: <alpine.DEB.2.02.1406112348430.23724@chino.kir.corp.google.com>
References: <1402537537-17945-1-git-send-email-ytk.lee@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Yongtaek Lee wrote:

> This bug was introduced by commit 92eb77d ("Input: evdev - fall back
> to vmalloc for client event buffer").
> 
> vzalloc is used to alloc memory as fallback in case of failure
> of kzalloc. But err_free_client was not considered on below case.
> 1. kzalloc fail
> 2. vzalloc success
> 3. evdev_open_device fail
> 4. kfree
> 
> So that address checking is needed to call correct free function.
> 
> Signed-off-by: Yongtaek Lee <ytk.lee@samsung.com>
> Reviewed-by: Daniel Stone <daniels@collabora.com>

Acked-by: David Rientjes <rientjes@google.com>
