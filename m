Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaBZWob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:44:31 -0500
Received: from arlo.cworth.org ([50.126.95.6]:51971 "EHLO arlo.cworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbaBZWo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:44:27 -0500
From: Carl Worth <cworth@cworth.org>
To: Ping Cheng <pingc@wacom.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: wacom: Fixes for stylus pressure values for Thinkpad Yoga
Date: Wed, 26 Feb 2014 14:38:13 -0800
Message-Id: <1393454296-32735-1-git-send-email-cworth@cworth.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes the pressure values reported for the
wacom tablet built-in to a Lenovo ThinkPad Yoga laptop. Prior to this
patch series, if I slowly increased stylus pressure, (expecting a
gradual increase of values from 0 to 1023), I instead received values
that increased slowly to 255, then reset to 0 and increased slowly
again, etc.

The buggy arithmetic that is updated here appears to exist in
identical forms for other drivers. I did not update any code that I
was not able to test directly. But it looks like wacom_pl_irq and
wacom_dtu_irq potentially have similar bugs, (depending on the actual
pressure_max values encountered in practice).

