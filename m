Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbaGCPLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:11:07 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53660 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaGCPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:11:05 -0400
Message-Id: <20140703143318.568554771@openvz.org>
User-Agent: quilt/0.60-1
Date: Thu, 03 Jul 2014 18:33:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: gorcunov@openvz.org
Subject: [RFC 0/2] prctl: set-mm -- Rework interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While been implementing c/r for user-namespaces we found that
having CAP_SYS_RESOURCE requirement in prctl set-mm opcode is somewhat
inconvenient and doesn't allow us to proceed restore of user-ns
since we loose CAP_SYS_RESOURCE upon new user-ns creation.

So it looks better to provide new interface and deprecate old one
leaving cap-sys-resource behind.

I would highly appreciate any comments on validate_prctl_map_locked()
helper in second patch which tests for new struct mm_struct values
being sane. I hope I didn't miss something obvious but as fas as
I see even using some "bad" values can't affect the kernel since
members are used mostly for statistics purpose.

Please take a look once time permit, any comments are highly
appreciated.

	Cyrill
