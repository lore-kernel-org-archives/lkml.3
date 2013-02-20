Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3BTVT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:19:58 -0500
Received: from mout.perfora.net ([74.208.4.195]:59077 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab3BTVT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:19:57 -0500
Message-ID: <51253CCE.6020409@nctritech.com>
Date: Wed, 20 Feb 2013 16:14:54 -0500
From: Jody - Tritech Computer Solutions <jody@nctritech.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Wood <andrew.wood@ivarch.com>, linux-kernel@vger.kernel.org
Subject: Re: CIFS 'cache=strict' breaks 'pv' utility
References: <5124FB41.5000106@nctritech.com> <20130220205159.GA1417@ivarch.com>
In-Reply-To: <20130220205159.GA1417@ivarch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:DSujL1araRNoz/thdDFmEveNsAfmr7vRkeaK28d3J7W
 sjB+WKJb68ZVZ0dOuKK0sXg3ANUN3Bs7o3M1pys0/ZftvUqoiN
 Haz2FmGs0pyRAdVs85w8tv/UTh2OPJPSCzJaFXh2klFx6jOdjM
 eZhciDMmG5sfa4Hm5N3G8U0vWlaZOPFk6JSZoTy58mgQqQp7D7
 jrVYq0W1QBqZEYR1EnuifO3VqBzzWU0Mukc8UWfkskVlO10e/P
 bukxomrSh0rlii7LxpY7qAKFPLyWcPd646MJs25EILeOiSSyki
 tPKuXPL1JFZ4aXlERc6ilGra1okbveoCfBG6lbCBgoANcwra7D
 QvG9DBgdjQJJDimSiRPqiQLo14AhdmPfBeHX8hLqm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may also be helpful. I turned on CIFS debugging and you can see 
where it attempts to transfer the last chunk of the file under 524288 
bytes in size and simply stops working:

[ 1160.462204] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr 
as Xid: 132 with uid: 0
[ 1160.462212] fs/cifs/inode.c: Update attributes: /source inode 
0xf616ceb0 count 1 dentry: 0xf6119700 d_time -267213 jiffies 860462
[ 1160.462215] fs/cifs/inode.c: Getting info on /source
[ 1160.462219] fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /source
[ 1160.462227] fs/cifs/transport.c: For smb_command 50
[ 1160.462231] fs/cifs/transport.c: Sending smb: smb_len=88
[ 1160.462937] fs/cifs/connect.c: RFC1002 header 0xa0
[ 1160.462959] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=243 
state=4
[ 1160.462965] fs/cifs/inode.c: cifs_revalidate_cache: revalidating 
inode 4161240587
[ 1160.462968] fs/cifs/inode.c: cifs_revalidate_cache: inode 4161240587 
is unchanged
[ 1160.462973] fs/cifs/inode.c: CIFS VFS: leaving 
cifs_revalidate_dentry_attr (xid = 132) rc = 0
[ 1160.462977] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr 
as Xid: 133 with uid: 0
[ 1160.462982] fs/cifs/inode.c: Update attributes: 
/source/unixutils.tar.xz inode 0xf618b6a8 count 1 dentry: 0xf6166a80 
d_time -267213 jiffies 860462
[ 1160.462985] fs/cifs/inode.c: Getting info on /source/unixutils.tar.xz
[ 1160.462988] fs/cifs/cifssmb.c: In QPathInfo (Unix) the path 
/source/unixutils.tar.xz
[ 1160.462992] fs/cifs/transport.c: For smb_command 50
[ 1160.462994] fs/cifs/transport.c: Sending smb: smb_len=122
[ 1160.463341] fs/cifs/connect.c: RFC1002 header 0xa0
[ 1160.463351] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=244 
state=4
[ 1160.463357] fs/cifs/inode.c: cifs_revalidate_cache: revalidating 
inode 4181251699
[ 1160.463360] fs/cifs/inode.c: cifs_revalidate_cache: inode 4181251699 
is unchanged
[ 1160.463363] fs/cifs/inode.c: CIFS VFS: leaving 
cifs_revalidate_dentry_attr (xid = 133) rc = 0
[ 1160.463423] fs/cifs/file.c: CIFS VFS: in cifs_open as Xid: 134 with 
uid: 0
[ 1160.463427] fs/cifs/file.c: inode = 0xf618b6a8 file flags are 0x8000 
for /source/unixutils.tar.xz
[ 1160.463430] fs/cifs/file.c: posix open /source/unixutils.tar.xz
[ 1160.463433] fs/cifs/cifssmb.c: In POSIX Create
[ 1160.463438] fs/cifs/transport.c: For smb_command 50
[ 1160.463441] fs/cifs/transport.c: Sending smb: smb_len=142
[ 1160.463833] fs/cifs/connect.c: RFC1002 header 0xac
[ 1160.463843] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=245 
state=4
[ 1160.463846] fs/cifs/cifssmb.c: copying inode info
[ 1160.463849] fs/cifs/inode.c: cifs_revalidate_cache: revalidating 
inode 4181251699
[ 1160.463852] fs/cifs/inode.c: cifs_revalidate_cache: inode 4181251699 
is unchanged
[ 1160.463855] fs/cifs/file.c: posix open succeeded
[ 1160.463860] fs/cifs/file.c: CIFS VFS: leaving cifs_open (xid = 134) 
rc = 0
[ 1160.463868] fs/cifs/ioctl.c: CIFS VFS: in cifs_ioctl as Xid: 135 with 
uid: 0
[ 1160.463871] fs/cifs/ioctl.c: ioctl file f5e67000  cmd 21505  arg 
3215103448
[ 1160.463874] fs/cifs/ioctl.c: unsupported ioctl
[ 1160.463876] fs/cifs/ioctl.c: CIFS VFS: leaving cifs_ioctl (xid = 135) 
rc = -25
[ 1160.463938] fs/cifs/cifssmb.c: cifs_async_readv: offset=0 bytes=524288
[ 1160.463942] fs/cifs/transport.c: For smb_command 46
[ 1160.463944] fs/cifs/transport.c: Sending smb: smb_len=59
[ 1160.464279] fs/cifs/connect.c: RFC1002 header 0x8003b
[ 1160.464284] fs/cifs/cifssmb.c: cifs_readv_receive: mid=246 offset=0 
bytes=524288
[ 1160.464288] fs/cifs/cifssmb.c: cifs_readv_receive: total_read=63 
data_offset=63
[ 1160.464291] fs/cifs/cifssmb.c: 0: iov_base=f5ecac40 iov_len=63
[ 1160.464295] fs/cifs/file.c: 0: iov_base=ff828000 iov_len=4096
[ 1160.464662] fs/cifs/file.c: 1: iov_base=ff81d000 iov_len=4096
[ 1160.465044] fs/cifs/file.c: 2: iov_base=ff825000 iov_len=4096
[ 1160.465399] fs/cifs/file.c: 3: iov_base=ff90f000 iov_len=4096
[ 1160.465765] fs/cifs/file.c: 4: iov_base=ff818000 iov_len=4096
[ 1160.466143] fs/cifs/file.c: 5: iov_base=ff81a000 iov_len=4096
[ 1160.466384] fs/cifs/file.c: 6: iov_base=ff8cf000 iov_len=4096
[ 1160.466749] fs/cifs/file.c: 7: iov_base=ff910000 iov_len=4096
[ 1160.467127] fs/cifs/file.c: 8: iov_base=ff819000 iov_len=4096
[ 1160.467488] fs/cifs/file.c: 9: iov_base=ff918000 iov_len=4096
[ 1160.467859] fs/cifs/file.c: 10: iov_base=ff826000 iov_len=4096
[ 1160.468230] fs/cifs/file.c: 11: iov_base=ff827000 iov_len=4096
[ 1160.468473] fs/cifs/file.c: 12: iov_base=ff823000 iov_len=4096
[ 1160.468844] fs/cifs/file.c: 13: iov_base=ff821000 iov_len=4096
[ 1160.469214] fs/cifs/file.c: 14: iov_base=ff8bb000 iov_len=4096
[ 1160.469584] fs/cifs/file.c: 15: iov_base=ff820000 iov_len=4096
[ 1160.469869] fs/cifs/file.c: 16: iov_base=ff90e000 iov_len=4096
[ 1160.470240] fs/cifs/file.c: 17: iov_base=ff81b000 iov_len=4096
[ 1160.470602] fs/cifs/file.c: 18: iov_base=ff81f000 iov_len=4096
[ 1160.470973] fs/cifs/file.c: 19: iov_base=ff90d000 iov_len=4096
[ 1160.471343] fs/cifs/file.c: 20: iov_base=ff830000 iov_len=4096
[ 1160.471711] fs/cifs/file.c: 21: iov_base=ff82e000 iov_len=4096
[ 1160.471957] fs/cifs/file.c: 22: iov_base=ff831000 iov_len=4096
[ 1160.472329] fs/cifs/file.c: 23: iov_base=ff82c000 iov_len=4096
[ 1160.472695] fs/cifs/file.c: 24: iov_base=ff82b000 iov_len=4096
[ 1160.473084] fs/cifs/file.c: 25: iov_base=ff82f000 iov_len=4096
[ 1160.473433] fs/cifs/file.c: 26: iov_base=ff82d000 iov_len=4096
[ 1160.473801] fs/cifs/file.c: 27: iov_base=ff829000 iov_len=4096
[ 1160.474093] fs/cifs/file.c: 28: iov_base=ff82a000 iov_len=4096
[ 1160.474419] fs/cifs/file.c: 29: iov_base=ff841000 iov_len=4096
[ 1160.474784] fs/cifs/file.c: 30: iov_base=ff842000 iov_len=4096
[ 1160.475162] fs/cifs/file.c: 31: iov_base=ff843000 iov_len=4096
[ 1160.475441] fs/cifs/file.c: 32: iov_base=ff844000 iov_len=4096
[ 1160.475808] fs/cifs/file.c: 33: iov_base=ff833000 iov_len=4096
[ 1160.476181] fs/cifs/file.c: 34: iov_base=ff834000 iov_len=4096
[ 1160.476547] fs/cifs/file.c: 35: iov_base=ff837000 iov_len=4096
[ 1160.476913] fs/cifs/file.c: 36: iov_base=ff838000 iov_len=4096
[ 1160.477291] fs/cifs/file.c: 37: iov_base=ff839000 iov_len=4096
[ 1160.477531] fs/cifs/file.c: 38: iov_base=ff83a000 iov_len=4096
[ 1160.477898] fs/cifs/file.c: 39: iov_base=ff83b000 iov_len=4096
[ 1160.478276] fs/cifs/file.c: 40: iov_base=ff83c000 iov_len=4096
[ 1160.478636] fs/cifs/file.c: 41: iov_base=ff83d000 iov_len=4096
[ 1160.479020] fs/cifs/file.c: 42: iov_base=ff83e000 iov_len=4096
[ 1160.479378] fs/cifs/file.c: 43: iov_base=ff83f000 iov_len=4096
[ 1160.479621] fs/cifs/file.c: 44: iov_base=ff840000 iov_len=4096
[ 1160.479992] fs/cifs/file.c: 45: iov_base=ff845000 iov_len=4096
[ 1160.480364] fs/cifs/file.c: 46: iov_base=ff846000 iov_len=4096
[ 1160.480730] fs/cifs/file.c: 47: iov_base=ff847000 iov_len=4096
[ 1160.481063] fs/cifs/file.c: 48: iov_base=ff848000 iov_len=4096
[ 1160.481383] fs/cifs/file.c: 49: iov_base=ff849000 iov_len=4096
[ 1160.481751] fs/cifs/file.c: 50: iov_base=ff84a000 iov_len=4096
[ 1160.482128] fs/cifs/file.c: 51: iov_base=ff84b000 iov_len=4096
[ 1160.482488] fs/cifs/file.c: 52: iov_base=ff84c000 iov_len=4096
[ 1160.482858] fs/cifs/file.c: 53: iov_base=ff84d000 iov_len=4096
[ 1160.483109] fs/cifs/file.c: 54: iov_base=ff84e000 iov_len=4096
[ 1160.483474] fs/cifs/file.c: 55: iov_base=ff857000 iov_len=4096
[ 1160.483844] fs/cifs/file.c: 56: iov_base=ff858000 iov_len=4096
[ 1160.484215] fs/cifs/file.c: 57: iov_base=ff859000 iov_len=4096
[ 1160.484582] fs/cifs/file.c: 58: iov_base=ff85a000 iov_len=4096
[ 1160.484947] fs/cifs/file.c: 59: iov_base=ff877000 iov_len=4096
[ 1160.485198] fs/cifs/file.c: 60: iov_base=ff878000 iov_len=4096
[ 1160.485567] fs/cifs/file.c: 61: iov_base=ff879000 iov_len=4096
[ 1160.485934] fs/cifs/file.c: 62: iov_base=ff87a000 iov_len=4096
[ 1160.486308] fs/cifs/file.c: 63: iov_base=ff85b000 iov_len=4096
[ 1160.486586] fs/cifs/file.c: 64: iov_base=ff85c000 iov_len=4096
[ 1160.486956] fs/cifs/file.c: 65: iov_base=ff85d000 iov_len=4096
[ 1160.487328] fs/cifs/file.c: 66: iov_base=ff85e000 iov_len=4096
[ 1160.487695] fs/cifs/file.c: 67: iov_base=ff85f000 iov_len=4096
[ 1160.488083] fs/cifs/file.c: 68: iov_base=ff860000 iov_len=4096
[ 1160.488433] fs/cifs/file.c: 69: iov_base=ff861000 iov_len=4096
[ 1160.488678] fs/cifs/file.c: 70: iov_base=ff862000 iov_len=4096
[ 1160.489093] fs/cifs/file.c: 71: iov_base=ff863000 iov_len=4096
[ 1160.489419] fs/cifs/file.c: 72: iov_base=ff864000 iov_len=4096
[ 1160.489784] fs/cifs/file.c: 73: iov_base=ff865000 iov_len=4096
[ 1160.490161] fs/cifs/file.c: 74: iov_base=ff866000 iov_len=4096
[ 1160.490521] fs/cifs/file.c: 75: iov_base=ff867000 iov_len=4096
[ 1160.490767] fs/cifs/file.c: 76: iov_base=ff868000 iov_len=4096
[ 1160.491145] fs/cifs/file.c: 77: iov_base=ff869000 iov_len=4096
[ 1160.491507] fs/cifs/file.c: 78: iov_base=ff86a000 iov_len=4096
[ 1160.491878] fs/cifs/file.c: 79: iov_base=ff86b000 iov_len=4096
[ 1160.492179] fs/cifs/file.c: 80: iov_base=ff86c000 iov_len=4096
[ 1160.492531] fs/cifs/file.c: 81: iov_base=ff86d000 iov_len=4096
[ 1160.492896] fs/cifs/file.c: 82: iov_base=ff86e000 iov_len=4096
[ 1160.493273] fs/cifs/file.c: 83: iov_base=ff86f000 iov_len=4096
[ 1160.493635] fs/cifs/file.c: 84: iov_base=ff870000 iov_len=4096
[ 1160.494071] fs/cifs/file.c: 85: iov_base=ff871000 iov_len=4096
[ 1160.494255] fs/cifs/file.c: 86: iov_base=ff872000 iov_len=4096
[ 1160.494619] fs/cifs/file.c: 87: iov_base=ff873000 iov_len=4096
[ 1160.494990] fs/cifs/file.c: 88: iov_base=ff874000 iov_len=4096
[ 1160.495362] fs/cifs/file.c: 89: iov_base=ff875000 iov_len=4096
[ 1160.495728] fs/cifs/file.c: 90: iov_base=ff876000 iov_len=4096
[ 1160.496104] fs/cifs/file.c: 91: iov_base=ff84f000 iov_len=4096
[ 1160.496343] fs/cifs/file.c: 92: iov_base=ff850000 iov_len=4096
[ 1160.496714] fs/cifs/file.c: 93: iov_base=ff851000 iov_len=4096
[ 1160.497089] fs/cifs/file.c: 94: iov_base=ff852000 iov_len=4096
[ 1160.497451] fs/cifs/file.c: 95: iov_base=ff88b000 iov_len=4096
[ 1160.497738] fs/cifs/file.c: 96: iov_base=ff88c000 iov_len=4096
[ 1160.498111] fs/cifs/file.c: 97: iov_base=ff88d000 iov_len=4096
[ 1160.498470] fs/cifs/file.c: 98: iov_base=ff88e000 iov_len=4096
[ 1160.498841] fs/cifs/file.c: 99: iov_base=ff88f000 iov_len=4096
[ 1160.499209] fs/cifs/file.c: 100: iov_base=ff890000 iov_len=4096
[ 1160.499579] fs/cifs/file.c: 101: iov_base=ff891000 iov_len=4096
[ 1160.499826] fs/cifs/file.c: 102: iov_base=ff892000 iov_len=4096
[ 1160.500205] fs/cifs/file.c: 103: iov_base=ff893000 iov_len=4096
[ 1160.500564] fs/cifs/file.c: 104: iov_base=ff894000 iov_len=4096
[ 1160.500931] fs/cifs/file.c: 105: iov_base=ff895000 iov_len=4096
[ 1160.501308] fs/cifs/file.c: 106: iov_base=ff896000 iov_len=4096
[ 1160.501669] fs/cifs/file.c: 107: iov_base=ff897000 iov_len=4096
[ 1160.501915] fs/cifs/file.c: 108: iov_base=ff899000 iov_len=4096
[ 1160.502294] fs/cifs/file.c: 109: iov_base=ff89a000 iov_len=4096
[ 1160.502653] fs/cifs/file.c: 110: iov_base=ff89b000 iov_len=4096
[ 1160.503077] fs/cifs/file.c: 111: iov_base=ff87b000 iov_len=4096
[ 1160.503308] fs/cifs/file.c: 112: iov_base=ff87c000 iov_len=4096
[ 1160.503680] fs/cifs/file.c: 113: iov_base=ff87d000 iov_len=4096
[ 1160.504094] fs/cifs/file.c: 114: iov_base=ff87e000 iov_len=4096
[ 1160.504416] fs/cifs/file.c: 115: iov_base=ff87f000 iov_len=4096
[ 1160.504782] fs/cifs/file.c: 116: iov_base=ff880000 iov_len=4096
[ 1160.505161] fs/cifs/file.c: 117: iov_base=ff881000 iov_len=4096
[ 1160.505400] fs/cifs/file.c: 118: iov_base=ff882000 iov_len=4096
[ 1160.505768] fs/cifs/file.c: 119: iov_base=ff883000 iov_len=4096
[ 1160.506148] fs/cifs/file.c: 120: iov_base=ff884000 iov_len=4096
[ 1160.506506] fs/cifs/file.c: 121: iov_base=ff885000 iov_len=4096
[ 1160.506877] fs/cifs/file.c: 122: iov_base=ff886000 iov_len=4096
[ 1160.507248] fs/cifs/file.c: 123: iov_base=ff887000 iov_len=4096
[ 1160.507489] fs/cifs/file.c: 124: iov_base=ff888000 iov_len=4096
[ 1160.507860] fs/cifs/file.c: 125: iov_base=ff889000 iov_len=4096
[ 1160.508236] fs/cifs/file.c: 126: iov_base=ff88a000 iov_len=4096
[ 1160.508600] fs/cifs/file.c: 127: iov_base=ff853000 iov_len=4096
[ 1160.508885] fs/cifs/cifssmb.c: total_read=524351 buflen=524351 
remaining=524288
[ 1160.508890] fs/cifs/cifssmb.c: cifs_readv_callback: mid=246 state=4 
result=0 bytes=524288
[ 1160.508897] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 1160.509919] fs/cifs/cifssmb.c: cifs_async_readv: offset=524288 
bytes=524288
[ 1160.509925] fs/cifs/transport.c: For smb_command 46
[ 1160.509928] fs/cifs/transport.c: Sending smb: smb_len=59
[ 1160.510572] fs/cifs/connect.c: RFC1002 header 0x8003b
[ 1160.510578] fs/cifs/cifssmb.c: cifs_readv_receive: mid=247 
offset=524288 bytes=524288
[ 1160.510584] fs/cifs/cifssmb.c: cifs_readv_receive: total_read=63 
data_offset=63
[ 1160.510588] fs/cifs/cifssmb.c: 0: iov_base=f5ecac40 iov_len=63
[ 1160.510591] fs/cifs/file.c: 0: iov_base=ff853000 iov_len=4096
[ 1160.510956] fs/cifs/file.c: 1: iov_base=ff88a000 iov_len=4096
[ 1160.511326] fs/cifs/file.c: 2: iov_base=ff889000 iov_len=4096
[ 1160.511692] fs/cifs/file.c: 3: iov_base=ff888000 iov_len=4096
[ 1160.512088] fs/cifs/file.c: 4: iov_base=ff887000 iov_len=4096
[ 1160.512430] fs/cifs/file.c: 5: iov_base=ff886000 iov_len=4096
[ 1160.512677] fs/cifs/file.c: 6: iov_base=ff885000 iov_len=4096
[ 1160.513094] fs/cifs/file.c: 7: iov_base=ff884000 iov_len=4096
[ 1160.513415] fs/cifs/file.c: 8: iov_base=ff883000 iov_len=4096
[ 1160.513781] fs/cifs/file.c: 9: iov_base=ff882000 iov_len=4096
[ 1160.514159] fs/cifs/file.c: 10: iov_base=ff881000 iov_len=4096
[ 1160.514520] fs/cifs/file.c: 11: iov_base=ff880000 iov_len=4096
[ 1160.514766] fs/cifs/file.c: 12: iov_base=ff87f000 iov_len=4096
[ 1160.515143] fs/cifs/file.c: 13: iov_base=ff87e000 iov_len=4096
[ 1160.515504] fs/cifs/file.c: 14: iov_base=ff87d000 iov_len=4096
[ 1160.515876] fs/cifs/file.c: 15: iov_base=ff87c000 iov_len=4096
[ 1160.516173] fs/cifs/file.c: 16: iov_base=ff87b000 iov_len=4096
[ 1160.516529] fs/cifs/file.c: 17: iov_base=ff89b000 iov_len=4096
[ 1160.516895] fs/cifs/file.c: 18: iov_base=ff89a000 iov_len=4096
[ 1160.517272] fs/cifs/file.c: 19: iov_base=ff899000 iov_len=4096
[ 1160.517633] fs/cifs/file.c: 20: iov_base=ff897000 iov_len=4096
[ 1160.518067] fs/cifs/file.c: 21: iov_base=ff896000 iov_len=4096
[ 1160.518252] fs/cifs/file.c: 22: iov_base=ff895000 iov_len=4096
[ 1160.518618] fs/cifs/file.c: 23: iov_base=ff894000 iov_len=4096
[ 1160.518990] fs/cifs/file.c: 24: iov_base=ff893000 iov_len=4096
[ 1160.519359] fs/cifs/file.c: 25: iov_base=ff892000 iov_len=4096
[ 1160.519727] fs/cifs/file.c: 26: iov_base=ff891000 iov_len=4096
[ 1160.520102] fs/cifs/file.c: 27: iov_base=ff890000 iov_len=4096
[ 1160.520340] fs/cifs/file.c: 28: iov_base=ff88f000 iov_len=4096
[ 1160.520712] fs/cifs/file.c: 29: iov_base=ff88e000 iov_len=4096
[ 1160.521090] fs/cifs/file.c: 30: iov_base=ff88d000 iov_len=4096
[ 1160.521450] fs/cifs/file.c: 31: iov_base=ff88c000 iov_len=4096
[ 1160.521735] fs/cifs/file.c: 32: iov_base=ff88b000 iov_len=4096
[ 1160.522104] fs/cifs/file.c: 33: iov_base=ff852000 iov_len=4096
[ 1160.522470] fs/cifs/file.c: 34: iov_base=ff851000 iov_len=4096
[ 1160.522839] fs/cifs/file.c: 35: iov_base=ff850000 iov_len=4096
[ 1160.523211] fs/cifs/file.c: 36: iov_base=ff84f000 iov_len=4096
[ 1160.523577] fs/cifs/file.c: 37: iov_base=ff876000 iov_len=4096
[ 1160.523825] fs/cifs/file.c: 38: iov_base=ff875000 iov_len=4096
[ 1160.524196] fs/cifs/file.c: 39: iov_base=ff82a000 iov_len=4096
[ 1160.524563] fs/cifs/file.c: 40: iov_base=ff829000 iov_len=4096
[ 1160.524929] fs/cifs/file.c: 41: iov_base=ff82d000 iov_len=4096
[ 1160.525305] fs/cifs/file.c: 42: iov_base=ff82f000 iov_len=4096
[ 1160.525667] fs/cifs/file.c: 43: iov_base=ff82b000 iov_len=4096
[ 1160.525913] fs/cifs/file.c: 44: iov_base=ff82c000 iov_len=4096
[ 1160.526288] fs/cifs/file.c: 45: iov_base=ff831000 iov_len=4096
[ 1160.526653] fs/cifs/file.c: 46: iov_base=ff82e000 iov_len=4096
[ 1160.527074] fs/cifs/file.c: 47: iov_base=ff830000 iov_len=4096
[ 1160.527307] fs/cifs/file.c: 48: iov_base=ff90d000 iov_len=4096
[ 1160.527677] fs/cifs/file.c: 49: iov_base=ff81f000 iov_len=4096
[ 1160.528092] fs/cifs/file.c: 50: iov_base=ff81b000 iov_len=4096
[ 1160.528416] fs/cifs/file.c: 51: iov_base=ff90e000 iov_len=4096
[ 1160.528782] fs/cifs/file.c: 52: iov_base=ff820000 iov_len=4096
[ 1160.529156] fs/cifs/file.c: 53: iov_base=ff8bb000 iov_len=4096
[ 1160.529398] fs/cifs/file.c: 54: iov_base=ff821000 iov_len=4096
[ 1160.529765] fs/cifs/file.c: 55: iov_base=ff823000 iov_len=4096
[ 1160.530142] fs/cifs/file.c: 56: iov_base=ff827000 iov_len=4096
[ 1160.530504] fs/cifs/file.c: 57: iov_base=ff826000 iov_len=4096
[ 1160.530874] fs/cifs/file.c: 58: iov_base=ff918000 iov_len=4096
[ 1160.531245] fs/cifs/file.c: 59: iov_base=ff819000 iov_len=4096
[ 1160.531487] fs/cifs/file.c: 60: iov_base=ff910000 iov_len=4096
[ 1160.531860] fs/cifs/file.c: 61: iov_base=ff8cf000 iov_len=4096
[ 1160.532230] fs/cifs/file.c: 62: iov_base=ff81a000 iov_len=4096
[ 1160.532599] fs/cifs/file.c: 63: iov_base=ff818000 iov_len=4096
[ 1160.532881] fs/cifs/file.c: 64: iov_base=ff90f000 iov_len=4096
[ 1160.533254] fs/cifs/file.c: 65: iov_base=ff825000 iov_len=4096
[ 1160.533616] fs/cifs/file.c: 66: iov_base=ff81d000 iov_len=4096
[ 1160.533990] fs/cifs/file.c: 67: iov_base=ff828000 iov_len=4096
[ 1160.534358] fs/cifs/file.c: 68: iov_base=ff854000 iov_len=4096
[ 1160.534728] fs/cifs/file.c: 69: iov_base=ff873000 iov_len=4096
[ 1160.534974] fs/cifs/file.c: 70: iov_base=ff874000 iov_len=4096
[ 1160.535342] fs/cifs/file.c: 71: iov_base=ff84d000 iov_len=4096
[ 1160.535710] fs/cifs/file.c: 72: iov_base=ff84e000 iov_len=4096
[ 1160.536083] fs/cifs/file.c: 73: iov_base=ff84b000 iov_len=4096
[ 1160.536449] fs/cifs/file.c: 74: iov_base=ff84c000 iov_len=4096
[ 1160.536815] fs/cifs/file.c: 75: iov_base=ff849000 iov_len=4096
[ 1160.537095] fs/cifs/file.c: 76: iov_base=ff84a000 iov_len=4096
[ 1160.537435] fs/cifs/file.c: 77: iov_base=ff847000 iov_len=4096
[ 1160.537801] fs/cifs/file.c: 78: iov_base=ff848000 iov_len=4096
[ 1160.538178] fs/cifs/file.c: 79: iov_base=ff845000 iov_len=4096
[ 1160.538456] fs/cifs/file.c: 80: iov_base=ff846000 iov_len=4096
[ 1160.538824] fs/cifs/file.c: 81: iov_base=ff83f000 iov_len=4096
[ 1160.539194] fs/cifs/file.c: 82: iov_base=ff840000 iov_len=4096
[ 1160.539562] fs/cifs/file.c: 83: iov_base=ff83d000 iov_len=4096
[ 1160.539928] fs/cifs/file.c: 84: iov_base=ff83e000 iov_len=4096
[ 1160.540306] fs/cifs/file.c: 85: iov_base=ff83b000 iov_len=4096
[ 1160.540546] fs/cifs/file.c: 86: iov_base=ff83c000 iov_len=4096
[ 1160.540913] fs/cifs/file.c: 87: iov_base=ff839000 iov_len=4096
[ 1160.541289] fs/cifs/file.c: 88: iov_base=ff83a000 iov_len=4096
[ 1160.541652] fs/cifs/file.c: 89: iov_base=ff837000 iov_len=4096
[ 1160.542074] fs/cifs/file.c: 90: iov_base=ff838000 iov_len=4096
[ 1160.542390] fs/cifs/file.c: 91: iov_base=ff833000 iov_len=4096
[ 1160.542635] fs/cifs/file.c: 92: iov_base=ff834000 iov_len=4096
[ 1160.543081] fs/cifs/file.c: 93: iov_base=ff843000 iov_len=4096
[ 1160.543373] fs/cifs/file.c: 94: iov_base=ff844000 iov_len=4096
[ 1160.543746] fs/cifs/file.c: 95: iov_base=ff841000 iov_len=4096
[ 1160.544086] fs/cifs/file.c: 96: iov_base=ff842000 iov_len=4096
[ 1160.544399] fs/cifs/file.c: 97: iov_base=ff855000 iov_len=4096
[ 1160.544764] fs/cifs/file.c: 98: iov_base=ff856000 iov_len=4096
[ 1160.545142] fs/cifs/file.c: 99: iov_base=ff86f000 iov_len=4096
[ 1160.545502] fs/cifs/file.c: 100: iov_base=ff870000 iov_len=4096
[ 1160.545875] fs/cifs/file.c: 101: iov_base=ff871000 iov_len=4096
[ 1160.546126] fs/cifs/file.c: 102: iov_base=ff872000 iov_len=4096
[ 1160.546487] fs/cifs/file.c: 103: iov_base=ff86b000 iov_len=4096
[ 1160.546859] fs/cifs/file.c: 104: iov_base=ff86c000 iov_len=4096
[ 1160.547229] fs/cifs/file.c: 105: iov_base=ff86d000 iov_len=4096
[ 1160.547599] fs/cifs/file.c: 106: iov_base=ff86e000 iov_len=4096
[ 1160.547963] fs/cifs/file.c: 107: iov_base=ff867000 iov_len=4096
[ 1160.548214] fs/cifs/file.c: 108: iov_base=ff868000 iov_len=4096
[ 1160.548581] fs/cifs/file.c: 109: iov_base=ff869000 iov_len=4096
[ 1160.548949] fs/cifs/file.c: 110: iov_base=ff86a000 iov_len=4096
[ 1160.549323] fs/cifs/file.c: 111: iov_base=ff863000 iov_len=4096
[ 1160.549601] fs/cifs/file.c: 112: iov_base=ff864000 iov_len=4096
[ 1160.549972] fs/cifs/file.c: 113: iov_base=ff865000 iov_len=4096
[ 1160.550342] fs/cifs/file.c: 114: iov_base=ff866000 iov_len=4096
[ 1160.550710] fs/cifs/file.c: 115: iov_base=ff85f000 iov_len=4096
[ 1160.551085] fs/cifs/file.c: 116: iov_base=ff860000 iov_len=4096
[ 1160.551449] fs/cifs/file.c: 117: iov_base=ff861000 iov_len=4096
[ 1160.551701] fs/cifs/file.c: 118: iov_base=ff862000 iov_len=4096
[ 1160.552099] fs/cifs/file.c: 119: iov_base=ff85b000 iov_len=4096
[ 1160.552441] fs/cifs/file.c: 120: iov_base=ff85c000 iov_len=4096
[ 1160.552805] fs/cifs/file.c: 121: iov_base=ff85d000 iov_len=4096
[ 1160.553182] fs/cifs/file.c: 122: iov_base=ff85e000 iov_len=4096
[ 1160.553841] fs/cifs/file.c: 123: iov_base=ff857000 iov_len=4096
[ 1160.553848] fs/cifs/file.c: 124: iov_base=ff858000 iov_len=4096
[ 1160.554156] fs/cifs/file.c: 125: iov_base=ff859000 iov_len=4096
[ 1160.554530] fs/cifs/file.c: 126: iov_base=ff85a000 iov_len=4096
[ 1160.554898] fs/cifs/file.c: 127: iov_base=ff832000 iov_len=4096
[ 1160.555180] fs/cifs/cifssmb.c: total_read=524351 buflen=524351 
remaining=524288
[ 1160.555186] fs/cifs/cifssmb.c: cifs_readv_callback: mid=247 state=4 
result=0 bytes=524288
[ 1160.555202] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 1160.555832] fs/cifs/cifssmb.c: cifs_async_readv: offset=1048576 
bytes=524288
[ 1160.555840] fs/cifs/transport.c: For smb_command 46
[ 1160.555842] fs/cifs/transport.c: Sending smb: smb_len=59
[ 1160.556393] fs/cifs/connect.c: RFC1002 header 0x8003b
[ 1160.556399] fs/cifs/cifssmb.c: cifs_readv_receive: mid=248 
offset=1048576 bytes=524288
[ 1160.556404] fs/cifs/cifssmb.c: cifs_readv_receive: total_read=63 
data_offset=63
[ 1160.556407] fs/cifs/cifssmb.c: 0: iov_base=f5ecac40 iov_len=63
[ 1160.556411] fs/cifs/file.c: 0: iov_base=ff832000 iov_len=4096
[ 1160.556777] fs/cifs/file.c: 1: iov_base=ff85a000 iov_len=4096
[ 1160.557156] fs/cifs/file.c: 2: iov_base=ff859000 iov_len=4096
[ 1160.557517] fs/cifs/file.c: 3: iov_base=ff858000 iov_len=4096
[ 1160.557883] fs/cifs/file.c: 4: iov_base=ff857000 iov_len=4096
[ 1160.558253] fs/cifs/file.c: 5: iov_base=ff85e000 iov_len=4096
[ 1160.558504] fs/cifs/file.c: 6: iov_base=ff85d000 iov_len=4096
[ 1160.558867] fs/cifs/file.c: 7: iov_base=ff85c000 iov_len=4096
[ 1160.559240] fs/cifs/file.c: 8: iov_base=ff85b000 iov_len=4096
[ 1160.559607] fs/cifs/file.c: 9: iov_base=ff862000 iov_len=4096
[ 1160.560030] fs/cifs/file.c: 10: iov_base=ff861000 iov_len=4096
[ 1160.560352] fs/cifs/file.c: 11: iov_base=ff860000 iov_len=4096
[ 1160.560598] fs/cifs/file.c: 12: iov_base=ff85f000 iov_len=4096
[ 1160.560969] fs/cifs/file.c: 13: iov_base=ff866000 iov_len=4096
[ 1160.561336] fs/cifs/file.c: 14: iov_base=ff865000 iov_len=4096
[ 1160.561709] fs/cifs/file.c: 15: iov_base=ff864000 iov_len=4096
[ 1160.561984] fs/cifs/file.c: 16: iov_base=ff863000 iov_len=4096
[ 1160.562403] fs/cifs/file.c: 17: iov_base=ff86a000 iov_len=4096
[ 1160.562726] fs/cifs/file.c: 18: iov_base=ff869000 iov_len=4096
[ 1160.563100] fs/cifs/file.c: 19: iov_base=ff868000 iov_len=4096
[ 1160.563463] fs/cifs/file.c: 20: iov_base=ff867000 iov_len=4096
[ 1160.563837] fs/cifs/file.c: 21: iov_base=ff86e000 iov_len=4096
[ 1160.564101] fs/cifs/file.c: 22: iov_base=ff86d000 iov_len=4096
[ 1160.564509] fs/cifs/file.c: 23: iov_base=ff86c000 iov_len=4096
[ 1160.564823] fs/cifs/file.c: 24: iov_base=ff86b000 iov_len=4096
[ 1160.565186] fs/cifs/file.c: 25: iov_base=ff872000 iov_len=4096
[ 1160.565558] fs/cifs/file.c: 26: iov_base=ff871000 iov_len=4096
[ 1160.565924] fs/cifs/file.c: 27: iov_base=ff870000 iov_len=4096
[ 1160.566170] fs/cifs/file.c: 28: iov_base=ff86f000 iov_len=4096
[ 1160.566547] fs/cifs/file.c: 29: iov_base=ff856000 iov_len=4096
[ 1160.566908] fs/cifs/file.c: 30: iov_base=ff855000 iov_len=4096
[ 1160.567284] fs/cifs/file.c: 31: iov_base=ff842000 iov_len=4096
[ 1160.567576] fs/cifs/file.c: 32: iov_base=ff841000 iov_len=4096
[ 1160.567938] fs/cifs/file.c: 33: iov_base=ff844000 iov_len=4096
[ 1160.568304] fs/cifs/file.c: 34: iov_base=ff843000 iov_len=4096
[ 1160.568676] fs/cifs/file.c: 35: iov_base=ff834000 iov_len=4096
[ 1160.569090] fs/cifs/file.c: 36: iov_base=ff833000 iov_len=4096
[ 1160.569415] fs/cifs/file.c: 37: iov_base=ff828000 iov_len=4096
[ 1160.569659] fs/cifs/file.c: 38: iov_base=ff81d000 iov_len=4096
[ 1160.570094] fs/cifs/file.c: 39: iov_base=ff825000 iov_len=4096
[ 1160.570398] fs/cifs/file.c: 40: iov_base=ff90f000 iov_len=4096
[ 1160.570764] fs/cifs/file.c: 41: iov_base=ff818000 iov_len=4096
[ 1160.571138] fs/cifs/file.c: 42: iov_base=ff81a000 iov_len=4096
[ 1160.571505] fs/cifs/file.c: 43: iov_base=ff8cf000 iov_len=4096
[ 1160.571775] fs/cifs/file.c: 44: iov_base=ff910000 iov_len=4096
[ 1160.572129] fs/cifs/file.c: 45: iov_base=ff819000 iov_len=4096
[ 1160.572487] fs/cifs/file.c: 46: iov_base=ff918000 iov_len=4096
[ 1160.572858] fs/cifs/file.c: 47: iov_base=ff826000 iov_len=4096
[ 1160.573154] fs/cifs/file.c: 48: iov_base=ff827000 iov_len=4096
[ 1160.573512] fs/cifs/file.c: 49: iov_base=ff823000 iov_len=4096
[ 1160.573878] fs/cifs/file.c: 50: iov_base=ff821000 iov_len=4096
[ 1160.574255] fs/cifs/file.c: 51: iov_base=ff8bb000 iov_len=4096
[ 1160.574616] fs/cifs/file.c: 52: iov_base=ff820000 iov_len=4096
[ 1160.574989] fs/cifs/file.c: 53: iov_base=ff90e000 iov_len=4096
[ 1160.575241] fs/cifs/file.c: 54: iov_base=ff81b000 iov_len=4096
[ 1160.575601] fs/cifs/file.c: 55: iov_base=ff81f000 iov_len=4096
[ 1160.575973] fs/cifs/file.c: 56: iov_base=ff90d000 iov_len=4096
[ 1160.576345] fs/cifs/file.c: 57: iov_base=ff830000 iov_len=4096
[ 1160.576709] fs/cifs/file.c: 58: iov_base=ff82e000 iov_len=4096
[ 1160.577075] fs/cifs/file.c: 59: iov_base=ff831000 iov_len=4096
[ 1160.577323] fs/cifs/file.c: 60: iov_base=ff82c000 iov_len=4096
[ 1160.577695] fs/cifs/file.c: 61: iov_base=ff82b000 iov_len=4096
[ 1160.578096] fs/cifs/file.c: 62: iov_base=ff82f000 iov_len=4096
[ 1160.578434] fs/cifs/file.c: 63: iov_base=ff82d000 iov_len=4096
[ 1160.578717] fs/cifs/file.c: 64: iov_base=ff829000 iov_len=4096
[ 1160.579098] fs/cifs/file.c: 65: iov_base=ff82a000 iov_len=4096
[ 1160.579454] fs/cifs/file.c: 66: iov_base=ff920000 iov_len=4096
[ 1160.579825] fs/cifs/file.c: 67: iov_base=ff921000 iov_len=4096
[ 1160.580196] fs/cifs/file.c: 68: iov_base=ff837000 iov_len=4096
[ 1160.580562] fs/cifs/file.c: 69: iov_base=ff838000 iov_len=4096
[ 1160.580809] fs/cifs/file.c: 70: iov_base=ff839000 iov_len=4096
[ 1160.581183] fs/cifs/file.c: 71: iov_base=ff83a000 iov_len=4096
[ 1160.581547] fs/cifs/file.c: 72: iov_base=ff83b000 iov_len=4096
[ 1160.581913] fs/cifs/file.c: 73: iov_base=ff83c000 iov_len=4096
[ 1160.582292] fs/cifs/file.c: 74: iov_base=ff83d000 iov_len=4096
[ 1160.582650] fs/cifs/file.c: 75: iov_base=ff83e000 iov_len=4096
[ 1160.582897] fs/cifs/file.c: 76: iov_base=ff83f000 iov_len=4096
[ 1160.583277] fs/cifs/file.c: 77: iov_base=ff840000 iov_len=4096
[ 1160.583635] fs/cifs/file.c: 78: iov_base=ff845000 iov_len=4096
[ 1160.584020] fs/cifs/file.c: 79: iov_base=ff846000 iov_len=4096
[ 1160.584310] fs/cifs/file.c: 80: iov_base=ff847000 iov_len=4096
[ 1160.584659] fs/cifs/file.c: 81: iov_base=ff848000 iov_len=4096
[ 1160.585078] fs/cifs/file.c: 82: iov_base=ff849000 iov_len=4096
[ 1160.585398] fs/cifs/file.c: 83: iov_base=ff84a000 iov_len=4096
[ 1160.585766] fs/cifs/file.c: 84: iov_base=ff84b000 iov_len=4096
[ 1160.586141] fs/cifs/file.c: 85: iov_base=ff84c000 iov_len=4096
[ 1160.586381] fs/cifs/file.c: 86: iov_base=ff853000 iov_len=4096
[ 1160.586748] fs/cifs/file.c: 87: iov_base=ff854000 iov_len=4096
[ 1160.587126] fs/cifs/file.c: 88: iov_base=ff84d000 iov_len=4096
[ 1160.587488] fs/cifs/file.c: 89: iov_base=ff84e000 iov_len=4096
[ 1160.587858] fs/cifs/file.c: 90: iov_base=ff873000 iov_len=4096
[ 1160.588229] fs/cifs/file.c: 91: iov_base=ff874000 iov_len=4096
[ 1160.588471] fs/cifs/file.c: 92: iov_base=ff875000 iov_len=4096
[ 1160.588843] fs/cifs/file.c: 93: iov_base=ff876000 iov_len=4096
[ 1160.589214] fs/cifs/file.c: 94: iov_base=ff84f000 iov_len=4096
[ 1160.589581] fs/cifs/file.c: 95: iov_base=ff850000 iov_len=4096
[ 1160.589862] fs/cifs/file.c: 96: iov_base=ff851000 iov_len=4096
[ 1160.590238] fs/cifs/file.c: 97: iov_base=ff852000 iov_len=4096
[ 1160.590599] fs/cifs/file.c: 98: iov_base=ff922000 iov_len=4096
[ 1160.590972] fs/cifs/file.c: 99: iov_base=ff923000 iov_len=4096
[ 1160.591342] fs/cifs/file.c: 100: iov_base=ff924000 iov_len=4096
[ 1160.591710] fs/cifs/file.c: 101: iov_base=ff925000 iov_len=4096
[ 1160.591957] fs/cifs/file.c: 102: iov_base=ff88b000 iov_len=4096
[ 1160.592328] fs/cifs/file.c: 103: iov_base=ff88c000 iov_len=4096
[ 1160.592696] fs/cifs/file.c: 104: iov_base=ff88d000 iov_len=4096
[ 1160.593084] fs/cifs/file.c: 105: iov_base=ff88e000 iov_len=4096
[ 1160.593433] fs/cifs/file.c: 106: iov_base=ff88f000 iov_len=4096
[ 1160.593798] fs/cifs/file.c: 107: iov_base=ff890000 iov_len=4096
[ 1160.594094] fs/cifs/file.c: 108: iov_base=ff891000 iov_len=4096
[ 1160.594416] fs/cifs/file.c: 109: iov_base=ff892000 iov_len=4096
[ 1160.594782] fs/cifs/file.c: 110: iov_base=ff893000 iov_len=4096
[ 1160.595162] fs/cifs/file.c: 111: iov_base=ff894000 iov_len=4096
[ 1160.595439] fs/cifs/file.c: 112: iov_base=ff895000 iov_len=4096
[ 1160.595807] fs/cifs/file.c: 113: iov_base=ff896000 iov_len=4096
[ 1160.596181] fs/cifs/file.c: 114: iov_base=ff897000 iov_len=4096
[ 1160.596547] fs/cifs/file.c: 115: iov_base=ff899000 iov_len=4096
[ 1160.596913] fs/cifs/file.c: 116: iov_base=ff89a000 iov_len=4096
[ 1160.597289] fs/cifs/file.c: 117: iov_base=ff89b000 iov_len=4096
[ 1160.597530] fs/cifs/file.c: 118: iov_base=ff87b000 iov_len=4096
[ 1160.597896] fs/cifs/file.c: 119: iov_base=ff87c000 iov_len=4096
[ 1160.598274] fs/cifs/file.c: 120: iov_base=ff87d000 iov_len=4096
[ 1160.598637] fs/cifs/file.c: 121: iov_base=ff87e000 iov_len=4096
[ 1160.599077] fs/cifs/file.c: 122: iov_base=ff87f000 iov_len=4096
[ 1160.599372] fs/cifs/file.c: 123: iov_base=ff880000 iov_len=4096
[ 1160.599619] fs/cifs/file.c: 124: iov_base=ff881000 iov_len=4096
[ 1160.599990] fs/cifs/file.c: 125: iov_base=ff882000 iov_len=4096
[ 1160.600363] fs/cifs/file.c: 126: iov_base=ff883000 iov_len=4096
[ 1160.600728] fs/cifs/file.c: 127: iov_base=ff884000 iov_len=4096
[ 1160.601061] fs/cifs/cifssmb.c: total_read=524351 buflen=524351 
remaining=524288
[ 1160.601069] fs/cifs/cifssmb.c: cifs_readv_callback: mid=248 state=4 
result=0 bytes=524288
[ 1160.601074] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 1160.601695] fs/cifs/cifssmb.c: cifs_async_readv: offset=1572864 
bytes=524288
[ 1160.601703] fs/cifs/transport.c: For smb_command 46
[ 1160.601706] fs/cifs/transport.c: Sending smb: smb_len=59
[ 1160.602217] fs/cifs/connect.c: RFC1002 header 0x8003b
[ 1160.602222] fs/cifs/cifssmb.c: cifs_readv_receive: mid=249 
offset=1572864 bytes=524288
[ 1160.602227] fs/cifs/cifssmb.c: cifs_readv_receive: total_read=63 
data_offset=63
[ 1160.602230] fs/cifs/cifssmb.c: 0: iov_base=f5ecac40 iov_len=63
[ 1160.602234] fs/cifs/file.c: 0: iov_base=ff884000 iov_len=4096
[ 1160.602602] fs/cifs/file.c: 1: iov_base=ff883000 iov_len=4096
[ 1160.602970] fs/cifs/file.c: 2: iov_base=ff882000 iov_len=4096
[ 1160.603346] fs/cifs/file.c: 3: iov_base=ff881000 iov_len=4096
[ 1160.603707] fs/cifs/file.c: 4: iov_base=ff880000 iov_len=4096
[ 1160.604088] fs/cifs/file.c: 5: iov_base=ff87f000 iov_len=4096
[ 1160.604324] fs/cifs/file.c: 6: iov_base=ff87e000 iov_len=4096
[ 1160.604691] fs/cifs/file.c: 7: iov_base=ff87d000 iov_len=4096
[ 1160.605099] fs/cifs/file.c: 8: iov_base=ff87c000 iov_len=4096
[ 1160.605430] fs/cifs/file.c: 9: iov_base=ff87b000 iov_len=4096
[ 1160.605802] fs/cifs/file.c: 10: iov_base=ff89b000 iov_len=4096
[ 1160.606177] fs/cifs/file.c: 11: iov_base=ff89a000 iov_len=4096
[ 1160.606416] fs/cifs/file.c: 12: iov_base=ff899000 iov_len=4096
[ 1160.606785] fs/cifs/file.c: 13: iov_base=ff897000 iov_len=4096
[ 1160.607158] fs/cifs/file.c: 14: iov_base=ff896000 iov_len=4096
[ 1160.607522] fs/cifs/file.c: 15: iov_base=ff895000 iov_len=4096
[ 1160.607808] fs/cifs/file.c: 16: iov_base=ff894000 iov_len=4096
[ 1160.608183] fs/cifs/file.c: 17: iov_base=ff893000 iov_len=4096
[ 1160.608542] fs/cifs/file.c: 18: iov_base=ff892000 iov_len=4096
[ 1160.608913] fs/cifs/file.c: 19: iov_base=ff891000 iov_len=4096
[ 1160.609285] fs/cifs/file.c: 20: iov_base=ff890000 iov_len=4096
[ 1160.609654] fs/cifs/file.c: 21: iov_base=ff88f000 iov_len=4096
[ 1160.609898] fs/cifs/file.c: 22: iov_base=ff88e000 iov_len=4096
[ 1160.610272] fs/cifs/file.c: 23: iov_base=ff88d000 iov_len=4096
[ 1160.610636] fs/cifs/file.c: 24: iov_base=ff88c000 iov_len=4096
[ 1160.611055] fs/cifs/file.c: 25: iov_base=ff88b000 iov_len=4096
[ 1160.611375] fs/cifs/file.c: 26: iov_base=ff925000 iov_len=4096
[ 1160.611742] fs/cifs/file.c: 27: iov_base=ff924000 iov_len=4096
[ 1160.611988] fs/cifs/file.c: 28: iov_base=ff923000 iov_len=4096
[ 1160.612362] fs/cifs/file.c: 29: iov_base=ff922000 iov_len=4096
[ 1160.612725] fs/cifs/file.c: 30: iov_base=ff852000 iov_len=4096
[ 1160.613119] fs/cifs/file.c: 31: iov_base=ff851000 iov_len=4096
[ 1160.613389] fs/cifs/file.c: 32: iov_base=ff850000 iov_len=4096
[ 1160.613750] fs/cifs/file.c: 33: iov_base=ff84f000 iov_len=4096
[ 1160.614126] fs/cifs/file.c: 34: iov_base=ff876000 iov_len=4096
[ 1160.614488] fs/cifs/file.c: 35: iov_base=ff875000 iov_len=4096
[ 1160.614854] fs/cifs/file.c: 36: iov_base=ff874000 iov_len=4096
[ 1160.615231] fs/cifs/file.c: 37: iov_base=ff873000 iov_len=4096
[ 1160.615475] fs/cifs/file.c: 38: iov_base=ff84e000 iov_len=4096
[ 1160.615838] fs/cifs/file.c: 39: iov_base=ff84d000 iov_len=4096
[ 1160.616216] fs/cifs/file.c: 40: iov_base=ff82a000 iov_len=4096
[ 1160.616577] fs/cifs/file.c: 41: iov_base=ff82d000 iov_len=4096
[ 1160.616951] fs/cifs/file.c: 42: iov_base=ff82b000 iov_len=4096
[ 1160.617320] fs/cifs/file.c: 43: iov_base=ff82c000 iov_len=4096
[ 1160.617563] fs/cifs/file.c: 44: iov_base=ff831000 iov_len=4096
[ 1160.617934] fs/cifs/file.c: 45: iov_base=ff82e000 iov_len=4096
[ 1160.618303] fs/cifs/file.c: 46: iov_base=ff90d000 iov_len=4096
[ 1160.618672] fs/cifs/file.c: 47: iov_base=ff81f000 iov_len=4096
[ 1160.618955] fs/cifs/file.c: 48: iov_base=ff81b000 iov_len=4096
[ 1160.619330] fs/cifs/file.c: 49: iov_base=ff90e000 iov_len=4096
[ 1160.619690] fs/cifs/file.c: 50: iov_base=ff820000 iov_len=4096
[ 1160.620085] fs/cifs/file.c: 51: iov_base=ff8bb000 iov_len=4096
[ 1160.620429] fs/cifs/file.c: 52: iov_base=ff821000 iov_len=4096
[ 1160.620801] fs/cifs/file.c: 53: iov_base=ff823000 iov_len=4096
[ 1160.621096] fs/cifs/file.c: 54: iov_base=ff827000 iov_len=4096
[ 1160.621415] fs/cifs/file.c: 55: iov_base=ff826000 iov_len=4096
[ 1160.621784] fs/cifs/file.c: 56: iov_base=ff918000 iov_len=4096
[ 1160.622152] fs/cifs/file.c: 57: iov_base=ff819000 iov_len=4096
[ 1160.622522] fs/cifs/file.c: 58: iov_base=ff910000 iov_len=4096
[ 1160.622891] fs/cifs/file.c: 59: iov_base=ff8cf000 iov_len=4096
[ 1160.623137] fs/cifs/file.c: 60: iov_base=ff81a000 iov_len=4096
[ 1160.623507] fs/cifs/file.c: 61: iov_base=ff818000 iov_len=4096
[ 1160.623873] fs/cifs/file.c: 62: iov_base=ff90f000 iov_len=4096
[ 1160.624251] fs/cifs/file.c: 63: iov_base=ff825000 iov_len=4096
[ 1160.624531] fs/cifs/file.c: 64: iov_base=ff81d000 iov_len=4096
[ 1160.624900] fs/cifs/file.c: 65: iov_base=ff828000 iov_len=4096
[ 1160.625270] fs/cifs/file.c: 66: iov_base=ff81e000 iov_len=4096
[ 1160.625637] fs/cifs/file.c: 67: iov_base=ff81c000 iov_len=4096
[ 1160.626054] fs/cifs/file.c: 68: iov_base=ff885000 iov_len=4096
[ 1160.626373] fs/cifs/file.c: 69: iov_base=ff832000 iov_len=4096
[ 1160.626621] fs/cifs/file.c: 70: iov_base=ff830000 iov_len=4096
[ 1160.626986] fs/cifs/file.c: 71: iov_base=ff82f000 iov_len=4096
[ 1160.627364] fs/cifs/file.c: 72: iov_base=ff829000 iov_len=4096
[ 1160.627726] fs/cifs/file.c: 73: iov_base=ff83f000 iov_len=4096
[ 1160.628101] fs/cifs/file.c: 74: iov_base=ff840000 iov_len=4096
[ 1160.628463] fs/cifs/file.c: 75: iov_base=ff83d000 iov_len=4096
[ 1160.628710] fs/cifs/file.c: 76: iov_base=ff83e000 iov_len=4096
[ 1160.629099] fs/cifs/file.c: 77: iov_base=ff83b000 iov_len=4096
[ 1160.629448] fs/cifs/file.c: 78: iov_base=ff83c000 iov_len=4096
[ 1160.629821] fs/cifs/file.c: 79: iov_base=ff839000 iov_len=4096
[ 1160.630114] fs/cifs/file.c: 80: iov_base=ff83a000 iov_len=4096
[ 1160.630471] fs/cifs/file.c: 81: iov_base=ff837000 iov_len=4096
[ 1160.630839] fs/cifs/file.c: 82: iov_base=ff838000 iov_len=4096
[ 1160.631218] fs/cifs/file.c: 83: iov_base=ff841000 iov_len=4096
[ 1160.631577] fs/cifs/file.c: 84: iov_base=ff842000 iov_len=4096
[ 1160.631949] fs/cifs/file.c: 85: iov_base=ff835000 iov_len=4096
[ 1160.632201] fs/cifs/file.c: 86: iov_base=ff836000 iov_len=4096
[ 1160.632560] fs/cifs/file.c: 87: iov_base=ff843000 iov_len=4096
[ 1160.632931] fs/cifs/file.c: 88: iov_base=ff844000 iov_len=4096
[ 1160.633304] fs/cifs/file.c: 89: iov_base=ff833000 iov_len=4096
[ 1160.633670] fs/cifs/file.c: 90: iov_base=ff834000 iov_len=4096
[ 1160.634084] fs/cifs/file.c: 91: iov_base=ff845000 iov_len=4096
[ 1160.634283] fs/cifs/file.c: 92: iov_base=ff846000 iov_len=4096
[ 1160.634654] fs/cifs/file.c: 93: iov_base=ff847000 iov_len=4096
[ 1160.635082] fs/cifs/file.c: 94: iov_base=ff848000 iov_len=4096
[ 1160.635393] fs/cifs/file.c: 95: iov_base=ff849000 iov_len=4096
[ 1160.635677] fs/cifs/file.c: 96: iov_base=ff84a000 iov_len=4096
[ 1160.636105] fs/cifs/file.c: 97: iov_base=ff84b000 iov_len=4096
[ 1160.636413] fs/cifs/file.c: 98: iov_base=ff84c000 iov_len=4096
[ 1160.636783] fs/cifs/file.c: 99: iov_base=ff853000 iov_len=4096
[ 1160.637155] fs/cifs/file.c: 100: iov_base=ff854000 iov_len=4096
[ 1160.637521] fs/cifs/file.c: 101: iov_base=ff855000 iov_len=4096
[ 1160.637769] fs/cifs/file.c: 102: iov_base=ff856000 iov_len=4096
[ 1160.638142] fs/cifs/file.c: 103: iov_base=ff86f000 iov_len=4096
[ 1160.638507] fs/cifs/file.c: 104: iov_base=ff870000 iov_len=4096
[ 1160.638875] fs/cifs/file.c: 105: iov_base=ff871000 iov_len=4096
[ 1160.639250] fs/cifs/file.c: 106: iov_base=ff872000 iov_len=4096
[ 1160.639611] fs/cifs/file.c: 107: iov_base=ff86b000 iov_len=4096
[ 1160.639857] fs/cifs/file.c: 108: iov_base=ff86c000 iov_len=4096
[ 1160.640234] fs/cifs/file.c: 109: iov_base=ff86d000 iov_len=4096
[ 1160.640596] fs/cifs/file.c: 110: iov_base=ff86e000 iov_len=4096
[ 1160.640967] fs/cifs/file.c: 111: iov_base=ff867000 iov_len=4096
[ 1160.641266] fs/cifs/file.c: 112: iov_base=ff868000 iov_len=4096
[ 1160.641619] fs/cifs/file.c: 113: iov_base=ff869000 iov_len=4096
[ 1160.641986] fs/cifs/file.c: 114: iov_base=ff86a000 iov_len=4096
[ 1160.642363] fs/cifs/file.c: 115: iov_base=ff863000 iov_len=4096
[ 1160.642724] fs/cifs/file.c: 116: iov_base=ff864000 iov_len=4096
[ 1160.643099] fs/cifs/file.c: 117: iov_base=ff865000 iov_len=4096
[ 1160.643342] fs/cifs/file.c: 118: iov_base=ff866000 iov_len=4096
[ 1160.643709] fs/cifs/file.c: 119: iov_base=ff85f000 iov_len=4096
[ 1160.644099] fs/cifs/file.c: 120: iov_base=ff860000 iov_len=4096
[ 1160.644449] fs/cifs/file.c: 121: iov_base=ff861000 iov_len=4096
[ 1160.644818] fs/cifs/file.c: 122: iov_base=ff862000 iov_len=4096
[ 1160.645190] fs/cifs/file.c: 123: iov_base=ff85b000 iov_len=4096
[ 1160.645434] fs/cifs/file.c: 124: iov_base=ff85c000 iov_len=4096
[ 1160.645806] fs/cifs/file.c: 125: iov_base=ff85d000 iov_len=4096
[ 1160.646175] fs/cifs/file.c: 126: iov_base=ff85e000 iov_len=4096
[ 1160.646542] fs/cifs/file.c: 127: iov_base=ff857000 iov_len=4096
[ 1160.646823] fs/cifs/cifssmb.c: total_read=524351 buflen=524351 
remaining=524288
[ 1160.646827] fs/cifs/cifssmb.c: cifs_readv_callback: mid=249 state=4 
result=0 bytes=524288
[ 1160.646833] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 1160.647426] fs/cifs/cifssmb.c: cifs_async_readv: offset=2097152 
bytes=524288
[ 1160.647433] fs/cifs/transport.c: For smb_command 46
[ 1160.647435] fs/cifs/transport.c: Sending smb: smb_len=59
[ 1160.648377] fs/cifs/connect.c: RFC1002 header 0x2807
[ 1160.648383] fs/cifs/cifssmb.c: cifs_readv_receive: mid=250 
offset=2097152 bytes=524288
[ 1160.648387] fs/cifs/cifssmb.c: cifs_readv_receive: total_read=63 
data_offset=63
[ 1160.648390] fs/cifs/cifssmb.c: 0: iov_base=f5ecac40 iov_len=63
[ 1160.649129] fs/cifs/cifssmb.c: cifs_readv_callback: mid=250 state=16 
result=-5 bytes=524288
[ 1160.649135] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 1160.649589] fs/cifs/file.c: Flush inode f618b6a8 file f5e67000 rc 0
[ 1160.649598] fs/cifs/file.c: closing last open instance for inode f618b6a8
[ 1160.649602] fs/cifs/file.c: CIFS VFS: in cifsFileInfo_put as Xid: 136 
with uid: 0
[ 1160.649605] fs/cifs/cifssmb.c: In CIFSSMBClose
[ 1160.649609] fs/cifs/transport.c: For smb_command 4
[ 1160.649612] fs/cifs/transport.c: Sending smb: smb_len=41
[ 1160.650163] fs/cifs/connect.c: RFC1002 header 0x23
[ 1160.650173] fs/cifs/transport.c: cifs_sync_mid_result: cmd=4 mid=251 
state=4

