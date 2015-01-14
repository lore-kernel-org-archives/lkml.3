Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbbANH1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:27:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbANH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.18 060/150] x86: export get_xsave_addr
Date: Tue, 13 Jan 2015 23:22:11 -0800
Message-Id: <20150114072058.574241363@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit ba7b39203a3a18018173b87e73f27169bd8e5147 upstream.

get_xsave_addr is the API to access XSAVE states, and KVM would
like to use it.  Export it.

Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/xsave.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -738,3 +738,4 @@ void *get_xsave_addr(struct xsave_struct
 
 	return (void *)xsave + xstate_comp_offsets[feature];
 }
+EXPORT_SYMBOL_GPL(get_xsave_addr);


