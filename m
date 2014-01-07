Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaAGRmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:42:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:5084 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbaAGRmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:42:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,620,1384329600"; 
   d="scan'208";a="463015768"
Subject: [PATCH v2] checkpatch: Only flag FSF address, not gnu.org URL
To: joe@perches.com, gregkh@linuxfoundation.org, josh@joshtriplett.org
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Jan 2014 09:41:50 -0800
Message-ID: <20140107173926.8923.98340.stgit@ahduyck-cp2.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change restricts the check for the for the FSF address in the GPL
copyright statement so that it only flags the address, not the references to
the gnu.org/licenses URL which appears to be used in numerous drivers.  The
idea is to still allow some reference to an external copy of the GPL in the
event that files are copied out of the kernel tree without the COPYING file.

So for example this statement will still return an error:
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

However, this statement will not return an error after this patch:
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

v2: Rebased patch off of linux-next tree.
    Updated patch description to include motivation behind change.

 scripts/checkpatch.pl |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 07331d6..e7f2c65 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1970,14 +1970,12 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /\bYou should have received a copy/i ||
-		    $rawline =~ /\bwrite to the Free/i ||
+		if ($rawline =~ /\bwrite to the Free/i ||
 		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
 		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
 			$msg_type = \&CHK if ($file);
-			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
 				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}

