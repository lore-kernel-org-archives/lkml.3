Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3CSLyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:54:38 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:42235 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3CSLyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNMtY5tvAvyqyAyYRwBzfTtZKkDambDUTUNYwd0Q3XkXA@mail.gmail.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
	<51429D7A.30906@gmail.com>
	<5142ABD3.4040106@gmail.com>
	<CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
	<CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
	<51448AC9.7080105@gmail.com>
	<CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
	<CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com>
	<5144BB15.3020002@gmail.com>
	<CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com>
	<5145D236.70203@gmail.com>
	<CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com>
	<5147C821.6070703@gmail.com>
	<CACVXFVNMtY5tvAvyqyAyYRwBzfTtZKkDambDUTUNYwd0Q3XkXA@mail.gmail.com>
Date: Tue, 19 Mar 2013 19:54:36 +0800
Message-ID: <CACVXFVPV3mq=k-AZ1bYkAMdxwXD96Ty7DYeh9H9J=yvA4m=rGA@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e0139ff30033bd004d845c5cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0139ff30033bd004d845c5cc
Content-Type: text/plain; charset=ISO-8859-1

Hi Sasha,

On Tue, Mar 19, 2013 at 11:40 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi Sasha,
>
> On Tue, Mar 19, 2013 at 10:06 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> [  232.822703] sysfs_dir_pos-973 sysfs_dirent use after free: vx855(vx855)-bind, 0-25520352
>
> Looks filp->f_pos is changed as zero by llseek(), so may leave
> filp->private_data
> point to one refcount-balanced sysfs_dirent object, which will be put
> again afterwards.
>
> Hope we are luck this time, please try the attachment patch.

Looks the better and simpler way is to hold the i_mutex for llseek.
If you haven't test the v2, please ignore it and just test the attachment
v3 patch.


Thanks,
-- 
Ming Lei

--089e0139ff30033bd004d845c5cc
Content-Type: application/octet-stream; name="sysfs-fix-readdir-v3.patch"
Content-Disposition: attachment; filename="sysfs-fix-readdir-v3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heh07ncm1

ZGlmZiAtLWdpdCBhL2ZzL3N5c2ZzL2Rpci5jIGIvZnMvc3lzZnMvZGlyLmMKaW5kZXggMmZiZGZm
Ni4uMTlhZWJkMyAxMDA2NDQKLS0tIGEvZnMvc3lzZnMvZGlyLmMKKysrIGIvZnMvc3lzZnMvZGly
LmMKQEAgLTI4MCw2ICsyODAsMTEgQEAgdm9pZCByZWxlYXNlX3N5c2ZzX2RpcmVudChzdHJ1Y3Qg
c3lzZnNfZGlyZW50ICogc2QpCiAJICogc2QtPnNfcGFyZW50IHdvbid0IGNoYW5nZSBiZW5lYXRo
IHVzLgogCSAqLwogCXBhcmVudF9zZCA9IHNkLT5zX3BhcmVudDsKKwlpZighKHNkLT5zX2ZsYWdz
ICYgU1lTRlNfRkxBR19SRU1PVkVEKSkgeworCQlwcmludGsoIiVzLSVkIHN5c2ZzX2RpcmVudCB1
c2UgYWZ0ZXIgZnJlZTogJXMtJXNcbiIsCisJCQlfX2Z1bmNfXywgX19MSU5FX18sIHBhcmVudF9z
ZC0+c19uYW1lLCBzZC0+c19uYW1lKTsKKwkJZHVtcF9zdGFjaygpOworCX0KIAogCWlmIChzeXNm
c190eXBlKHNkKSA9PSBTWVNGU19LT0JKX0xJTkspCiAJCXN5c2ZzX3B1dChzZC0+c19zeW1saW5r
LnRhcmdldF9zZCk7CkBAIC05NjIsNiArOTY3LDEyIEBAIHN0YXRpYyBzdHJ1Y3Qgc3lzZnNfZGly
ZW50ICpzeXNmc19kaXJfcG9zKGNvbnN0IHZvaWQgKm5zLAogCQlpbnQgdmFsaWQgPSAhKHBvcy0+
c19mbGFncyAmIFNZU0ZTX0ZMQUdfUkVNT1ZFRCkgJiYKIAkJCXBvcy0+c19wYXJlbnQgPT0gcGFy
ZW50X3NkICYmCiAJCQloYXNoID09IHBvcy0+c19oYXNoOworCisJCWlmICgoYXRvbWljX3JlYWQo
JnBvcy0+c19jb3VudCkgPT0gMSkpIHsKKwkJCXByaW50aygiJXMtJWQgc3lzZnNfZGlyZW50IHVz
ZSBhZnRlciBmcmVlOiAlcyglcyktJXMsICVsbGQtJXVcbiIsCisJCQkJX19mdW5jX18sIF9fTElO
RV9fLCBwYXJlbnRfc2QtPnNfbmFtZSwgcG9zLT5zX3BhcmVudC0+c19uYW1lLAorCQkJCXBvcy0+
c19uYW1lLCBoYXNoLCBwb3MtPnNfaGFzaCk7CisJCX0KIAkJc3lzZnNfcHV0KHBvcyk7CiAJCWlm
ICghdmFsaWQpCiAJCQlwb3MgPSBOVUxMOwpAQCAtMTA1OCwxMCArMTA2OSwyMSBAQCBzdGF0aWMg
aW50IHN5c2ZzX3JlYWRkaXIoc3RydWN0IGZpbGUgKiBmaWxwLCB2b2lkICogZGlyZW50LCBmaWxs
ZGlyX3QgZmlsbGRpcikKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIGxvZmZfdCBzeXNmc19kaXJf
bGxzZWVrKHN0cnVjdCBmaWxlICpmaWxlLCBsb2ZmX3Qgb2Zmc2V0LCBpbnQgd2hlbmNlKQorewor
CQlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9pbm9kZShmaWxlKTsKKwkJbG9mZl90IHJldDsK
KworCQltdXRleF9sb2NrKCZpbm9kZS0+aV9tdXRleCk7CisJCXJldCA9IGdlbmVyaWNfZmlsZV9s
bHNlZWsoZmlsZSwgb2Zmc2V0LCB3aGVuY2UpOworCQltdXRleF91bmxvY2soJmlub2RlLT5pX211
dGV4KTsKKworCQlyZXR1cm4gcmV0OworfQogCiBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25z
IHN5c2ZzX2Rpcl9vcGVyYXRpb25zID0gewogCS5yZWFkCQk9IGdlbmVyaWNfcmVhZF9kaXIsCiAJ
LnJlYWRkaXIJPSBzeXNmc19yZWFkZGlyLAogCS5yZWxlYXNlCT0gc3lzZnNfZGlyX3JlbGVhc2Us
Ci0JLmxsc2VlawkJPSBnZW5lcmljX2ZpbGVfbGxzZWVrLAorCS5sbHNlZWsJCT0gc3lzZnNfZGly
X2xsc2VlaywKIH07Cg==
--089e0139ff30033bd004d845c5cc--
