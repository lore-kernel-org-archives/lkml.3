Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3F0Rfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:35:37 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56890 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752037Ab3F0Rfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:35:36 -0400
Date: Thu, 27 Jun 2013 13:35:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "David 'Digit' Turner" <digit@android.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Tom Keel <thomas.keel@intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: goldfish driver: Missing get_user_pages in
	goldfish_pipe_read_write()
Message-ID: <20130627173532.GA29405@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following code snippet:

drivers/platform/goldfish/goldfish_pipe.c:
goldfish_pipe_read_write()

                /* Ensure that the corresponding page is properly mapped */
                /* FIXME: this isn't safe or sufficient - use get_user_pages */
                if (is_write) {
                        char c;
                        /* Ensure that the page is mapped and readable */
                        if (__get_user(c, (char __user *)address)) {
                                if (!ret)
                                        ret = -EFAULT;
                                break;
                        }
                } else {
                        /* Ensure that the page is mapped and writable */
                        if (__put_user(0, (char __user *)address)) {
                                if (!ret)
                                        ret = -EFAULT;
                                break;
                        }
                }

Seems to lack the kind of validation required to make it fail properly
if the memory range is not fully populated.

I see that this feature has been merged in Linux kernel 3.9, but the
FIXME is still there in 3.10-rc7. Any plans on fixing this ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
