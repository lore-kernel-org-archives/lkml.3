Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaLABIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:08:10 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33939 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaLABII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:08:08 -0500
MIME-Version: 1.0
Date: Sun, 30 Nov 2014 19:08:07 -0600
Message-ID: <CAFZT-jKVYbCKMYt8ocahQ_0QV6N_A9VPFS5YYDf7tB2NnDHV_w@mail.gmail.com>
Subject: Possible memory leak in function (reserve_range) not freeing pointer (regionid)
From: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug Report: https://bugzilla.kernel.org/show_bug.cgi?id=89101
Linux Version [3.17-rc1]
Configuration: Default configuration for x86


Function (reserve_range) in file (drivers/pnp/system.c) allocates
pointer (regionid) on line (32) and passes it to function
(__request_region) through the macros: (request_region) at line (38)
or (request_mem_region) at line (40). However, if the resource (res)
is allocated through (__request_region) function, then the pointer
(res->name) points to the allocated pointer (regionid). Then, there is
no way in function (free_resource) or function (release_resource) to
free the pointer (regionid) or (res->name). Thus, causing a potential
memory leak!

Function (reserve_range) source code reference:
http://lxr.free-electrons.com/source/drivers/pnp/system.c#L25
Function (free_resource) source code
reference:http://lxr.free-electrons.com/source/kernel/resource.c#L172
Function (release_resource) source code
reference:http://lxr.free-electrons.com/source/kernel/resource.c#L322


~Ahmed
