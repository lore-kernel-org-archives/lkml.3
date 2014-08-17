Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaHQROI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:14:08 -0400
Received: from linuxhacker.ru ([217.76.32.60]:56422 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbaHQROG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:14:06 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH] lustre: Add some basic documentation
Date: Sun, 17 Aug 2014 13:13:51 -0400
Message-Id: <1408295631-11185-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds drivers/staging/lustre/README.txt with some
basic information about Lustre and how to use it.

Eventually this will need to move to Documentation/filesystems/lustre.txt

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/README.txt | 87 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 drivers/staging/lustre/README.txt

diff --git a/drivers/staging/lustre/README.txt b/drivers/staging/lustre/README.txt
new file mode 100644
index 0000000..cf0ca50
--- /dev/null
+++ b/drivers/staging/lustre/README.txt
@@ -0,0 +1,87 @@
+Lustre Parallel Filesystem Client
+=================================
+
+The Lustre file system is an open-source, parallel file system
+that supports many requirements of leadership class HPC simulation
+environments.
+Born from from a research project at Carnegie Mellon University,
+the Lustre file system is a widely-used option in HPC.
+The Lustre file system provides a POSIX compliant file system interface,
+can scale to thousands of clients, petabytes of storage and
+hundreds of gigabytes per second of I/O bandwidth.
+
+Unlike shared disk storage cluster filesystems (e.g. OCFS2, GFS, GPFS),
+Lustre has independent Metadata and Data servers that clients can access
+in parallel to maximize performance.
+
+In order to use Lustre client you will need to download lustre client
+tools from
+https://downloads.hpdd.intel.com/public/lustre/latest-feature-release/
+the package name is lustre-client.
+
+You will need to install and configure your Lustre servers separately.
+
+Mount Syntax
+============
+After you installed the lustre-client tools including mount.lustre binary
+you can mount your Lustre filesystem with:
+
+mount -t lustre mgs:/fsname mnt
+
+where mgs is the host name or ip address of your Lustre MGS(management service)
+fsname is the name of the filesystem you would like to mount.
+
+
+Mount Options
+=============
+
+  noflock
+	Disable posix file locking (Applications trying to use
+	the functionality will get ENOSYS)
+
+  localflock
+	Enable local flock support, using only client-local flock
+	(faster, for applications that require flock but do not run
+	 on multiple nodes).
+
+  flock
+	Enable cluster-global posix file locking coherent across all
+	client nodes.
+
+  user_xattr, nouser_xattr
+	Support "user." extended attributes (or not)
+
+  user_fid2path, nouser_fid2path
+	Enable FID to path translation by regular users (or not)
+
+  checksum, nochecksum
+	Verify data consistency on the wire and in memory as it passes
+	between the layers (or not).
+
+  lruresize, nolruresize
+	Allow lock LRU to be controlled by memory pressure on the server
+	(or only 100 (default, controlled by lru_size proc parameter) locks
+	 per CPU per server on this client).
+
+  lazystatfs, nolazystatfs
+	Do not block in statfs() if some of the servers are down.
+
+  32bitapi
+	Shrink inode numbers to fit into 32 bits. This is necessary
+	if you plan to reexport Lustre filesystem from this client via
+	NFSv4.
+
+  verbose, noverbose
+	Enable mount/umount console messages (or not)
+
+More Information
+================
+You can get more information at
+OpenSFS website: http://lustre.opensfs.org/about/
+Intel HPDD wiki: https://wiki.hpdd.intel.com
+
+Out of tree Lustre client and server code is available at:
+http://git.whamcloud.com/fs/lustre-release.git
+
+Latest binary packages:
+http://lustre.opensfs.org/download-lustre/
-- 
1.9.3

