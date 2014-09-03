Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaICVUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:36 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:53475 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 09/24] ARM64:ILP32: Use the same syscall names as LP64
Date: Wed,  3 Sep 2014 14:19:03 -0700
Message-Id: <1409779158-30963-10-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define __SYSCALL_NONCOMPAT so we use the 64bit naming scheme for ILP32.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/uapi/asm/unistd.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
index 1caadc2..13cbf8d 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -13,4 +13,10 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+
+/* For ILP32, we want to use the non compat names. */
+#if defined(__ILP32__)
+#define __ARCH_WANT_64BIT_SYSCALLS
+#endif
+
 #include <asm-generic/unistd.h>
-- 
1.7.2.5

