Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaHOQtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:49:05 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41254 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaHOQsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:50 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 10/10] lustre: Add some basic documentation
Date: Fri, 15 Aug 2014 12:48:15 -0400
Message-Id: <1408121295-29115-11-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Documentation/filesystems/lustre.txt with some
basic information about Lustre and how to use it.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 Documentation/filesystems/lustre.txt | 87 ++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 Documentation/filesystems/lustre.txt

diff --git a/Documentation/filesystems/lustre.txt b/Documentation/filesystems/lustre.txt
new file mode 100644
index 0000000..cf0ca50
--- /dev/null
+++ b/Documentation/filesystems/lustre.txt
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

