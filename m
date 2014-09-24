Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaIXLQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:16:13 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:42307 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIXLQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:16:11 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: rdunlap@infradead.org, viro@zeniv.linux.org.uk
Cc: linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        akpm@linux-foundation.org, keescook@chromium.org,
        penguin-kernel@I-love.SAKURA.ne.jp, rob.jones@codethink.co.uk
Subject: [PATCH RESUBMIT 0/2] fs/seq_file: Add seq_open_init()
Date: Wed, 24 Sep 2014 12:15:54 +0100
Message-Id: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series resubmitted due to a typo in an email address.

This patch series implements and documents a new interface function for
seq_file.

The existing set of open functions: seq_open(), seq_open_private() and
__seq_open_private() satisfy the majority of use cases however there is
one more use case that is also very common that this new function
addresses.

This case is where the iterator needs information that is available only at
the time the seq_file is opened but does not need any space allocated, e.g.
access to the inode structure. This type of open occurs, by my best estimate,
in well over 40 places. 

Using the new function saves at least two lines of boilerplate code per
instance as well as making the code easier to follow. The additional code
in seq_file.c to implement the function is minimal as the first place that
code can be removed is within seq_file.c itself.

Once this patch is accepted, the instances of boilerplate code can be
addressed.

The documentation of seq_open() and its variants has been re-worked to try
to guide users towards the most appropriate variant for their application.

Rob Jones (2):
  fs/seq_file: Create new function seq_open_init()
  Documentation/filesystem/seq_file: document seq_open_init()

 Documentation/filesystems/seq_file.txt |   58 +++++++++++++++++++++-----------
 fs/seq_file.c                          |   34 ++++++++++++-------
 include/linux/seq_file.h               |    1 +
 3 files changed, 62 insertions(+), 31 deletions(-)

-- 
1.7.10.4

