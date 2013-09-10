Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3IJB4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:56:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45653 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3IJB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:56:40 -0400
Date: Tue, 10 Sep 2013 11:56:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the dmaengine tree with the slave-dma
 tree
Message-Id: <20130910115621.fae74fee9d3d17a1e91feed4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Sep_2013_11_56_21_+1000_6hiUpFNtnFTl/qmA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Sep_2013_11_56_21_+1000_6hiUpFNtnFTl/qmA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the dmaengine tree got a conflict in
include/linux/dmaengine.h between commit 7bb587f4eef8 ("dmaengine: add
interface of dma_get_slave_channel") from the slave-dma tree and commit
4a43f394a082 ("dmaengine: dma_sync_wait and dma_find_channel undefined")
from the dmaengine tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/dmaengine.h
index 2601186,0c72b89..0000000
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@@ -1030,8 -1006,6 +1042,7 @@@ static inline void dma_release_channel(
  int dma_async_device_register(struct dma_device *device);
  void dma_async_device_unregister(struct dma_device *device);
  void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
- struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
 +struct dma_chan *dma_get_slave_channel(struct dma_chan *chan);
  struct dma_chan *net_dma_find_channel(void);
  #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x,=
 y)
  #define dma_request_slave_channel_compat(mask, x, y, dev, name) \

--Signature=_Tue__10_Sep_2013_11_56_21_+1000_6hiUpFNtnFTl/qmA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLnxQAAoJEECxmPOUX5FE5JwP/1v41FYf6xGUzVAI6EyWI/zA
DFfz+2ThJEn1jStknlNxPxSUJIHDSjCJjYJbxkVSf/Xx304r/EO7AWmZO2jZP1On
WShFT20D1b6V1L5sBIiLOTBnczxV584tDcib25zsk8/pOAB9wYVhsQ0v66Uby+A+
2f+Y4qDIWcNbKxEtvu0p65sKrXaQ14kmVTBUVIOVN89CMC+EQYYPZZVxEp+geznQ
YI7auuSOw9MzCR+uJK++xo+Wo+lb1hsNqZWghq/qwI1lGa2YiRv9n0l+gz9CvhhI
d3Gimvdrb4TKQallugQqqgRV429yd2729zXwqlyoQvNcgn8BmFS0KHhcUVuyPZKp
Kk22i3rwti6xjO3l2Oa8iqw97wv79aGDl6RY/TcLV2cTETjrmA1aenwhFzGJKV7x
Rp7oYTuLGavxeKsAJ6H4SO1k3i/nOf3ly/J79Xb8/dp+lNUUHkBn++FJjLbckTI6
LziD0mkLmXOw9Tly1WSTdHjOc3k6XKhE/bNjvtL0qw3mf/86Cze5Q7e84Z4VWLEn
4Pq6IBx41Dpt4i06sabnp/ErD6CSgnmRt6mtjrzCGJFX6ippzmvjtV/lxvXtCC0X
VPdH+vSZPziI46k6eW1QZw9q7Q/6zvR1lZJrSUUimIEY7NMx5Ryk3FYOqo6v/KCI
LveuXmMVjCgOx4U1VAcN
=E/kx
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Sep_2013_11_56_21_+1000_6hiUpFNtnFTl/qmA--
