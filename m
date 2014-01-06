Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492AbaAFXQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:16:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:14453 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933197AbaAFXQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:16:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,615,1384329600"; 
   d="scan'208";a="434756185"
Subject: [PATCH] checkpatch: Only flag FSF address, not gnu.org URL
To: joe@perches.com, gregkh@linuxfoundation.org, josh@joshtriplett.org
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 15:16:24 -0800
Message-ID: <20140106231534.23578.11475.stgit@ahduyck-cp2.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change restricts the check for the for the FSF address in the GPL
copyright statement so that it only flags the address, not the references to
the gnu.org/licenses URL which appear in numerous drivers.

So for example this statement will still return an error:
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

However, this statement will not return an error after this patch:
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 scripts/checkpatch.pl |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c98100..ba3c9c3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1963,8 +1963,7 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /You should have received a copy/ ||
-		    $rawline =~ /write to the Free Software/ ||
+		if ($rawline =~ /write to the Free Software/ ||
 		    $rawline =~ /59 Temple Place/ ||
 		    $rawline =~ /51 Franklin Street/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";

