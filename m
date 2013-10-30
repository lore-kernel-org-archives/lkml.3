Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3J3UWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:22:25 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34531 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3J3UWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:22:23 -0400
Message-Id: <20131030195951.201688764@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 Oct 2013 23:59:51 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/6] Rework file::show_fdinfo method to use seq-files engine
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, in criu we intensively use additional information provided by
/proc/<pid>/fdinfo/<fd> particular to the object opened file
represents. The output is printed out by file_operations::show_fdinfo
method and the implementation of this method is pretty simple. Still
I think better would be to convert this method to seq_operations pointer
where all suppliers (epoll, eventfd and such) provide own seq-file
operations. While this makes code a little more complex this will
decrease the amount of kernel memory needed for output (because
we won't need to provide all information in one pass but by chunks).

Please take a look, thanks!
