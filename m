Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaDUVhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:37:35 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33717 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaDUVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:37:32 -0400
MIME-Version: 1.0
From: Pranith Kumar <pranith@gatech.edu>
Date: Mon, 21 Apr 2014 17:37:01 -0400
X-Google-Sender-Auth: XJRWViZ7rJOh2D2CMPMy4qoKE-c
Message-ID: <CAJhHMCBrec++R-SOqHhZzNO8jimZWpEy5i-uM4UeLHG9yb-sqw@mail.gmail.com>
Subject: usage of rcu_dereference_raw
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I was trying to see the various uses of rcu_dereference_ functions to
understand how they were being used. A doubt cropped up while doing this:

* rcu_dereference_raw(): the documentation explicitly mentions that this
  should be minimally used as this does no checking of read critical sections
  and does not implement barriers. But looking at the code, there are various
  places where this is being used and it is being used I think in a buggy
  way. For example, in drivers/net/wireless/iwlwifi/dvm/main.c, there is this:

        kfree(rcu_dereference_raw(priv->noa_data));

  I can't imagine a scenario in which this is valid. So my question is this:
  do most of the uses of rcu_dereference_raw() need to be changed to use other
  dereference functions or are there cases where its usage is valid?

Regards,
-- 
Pranith
